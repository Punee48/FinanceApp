using FinanceApp.Data;
using FinanceApp.Data.Service;
using FinanceApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FinanceApp.Controllers
{
    public class ExpensesController : Controller
    {
        private readonly IExpensesService _expensesService;
        public ExpensesController(IExpensesService expensesService)
        {
            _expensesService = expensesService;
        }
        public async Task<IActionResult> Index()
        {
            //need to pull all expenses record from the DB
            var expenses = await _expensesService.GetAllExpenses();
            return View(expenses);
        }

        public  IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Create(Expense expense)
        {
            if (ModelState.IsValid)
            {
                await _expensesService.AddExpense(expense);
                return RedirectToAction("Index");
            }
            return View(expense);
        }

        public IActionResult GetChart()
        {
            var data = _expensesService.GetChartData();
            return Json(data);

        }
    }
}
