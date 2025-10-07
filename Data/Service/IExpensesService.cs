using FinanceApp.Models;

namespace FinanceApp.Data.Service
{
    public interface IExpensesService
    {
        Task<IEnumerable<Expense>> GetAllExpenses();
        Task AddExpense(Expense expense);
        IQueryable GetChartData();
    }
}
