using Microsoft.EntityFrameworkCore;
using TimeTrackerDb.Models;

namespace TimeTrackerDb;

public class TimeTrackerContext : DbContext
{
    public TimeTrackerContext(DbContextOptions<TimeTrackerContext> options)
        : base(options)
    {
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite("Data Source=app.db");   
    }

    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<TimeEntry> TimeEntries => Set<TimeEntry>();

}