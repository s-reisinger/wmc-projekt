using System.Runtime.CompilerServices;

namespace TimeTrackerDb.Models;

public class TimeEntry
{
    public int Id { get; set; }
    public DateTime Date { get; set; }
    public DateTime Start { get; set; }
    public DateTime? End { get; set; }
    public String Comment { get; set; }
    public Employee Employee { get; set; }
    public int EmployeeId { get; set; }
}