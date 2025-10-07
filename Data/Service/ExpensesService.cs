using FinanceApp.Models;
using Microsoft.EntityFrameworkCore;

namespace FinanceApp.Data.Service
{
    public class ExpensesService : IExpensesService
    {
        private readonly FinanceDbContext _financeDbContext;

        public ExpensesService(FinanceDbContext financeDbContext)
        {
            _financeDbContext = financeDbContext;
        }
        public async Task AddExpense(Expense expense)
        {
            await _financeDbContext.Expenses.AddAsync(expense);
            await _financeDbContext.SaveChangesAsync();
      
        }

        public async Task<IEnumerable<Expense>> GetAllExpenses()
        {
            var expenses = await _financeDbContext.Expenses.ToListAsync();
            return expenses;
        }

        public IQueryable GetChartData()
        {
            var data = _financeDbContext.Expenses.GroupBy(e => e.Categoty).Select(g => new
            {
                Categoty = g.Key,
                Total = g.Sum(e => e.Amount)
            });

            return data;
        }
    }
}
