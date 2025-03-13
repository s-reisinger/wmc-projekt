namespace TimeTrackerDb.Models;

public class Employee
{
    public int Id { get; set; }
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String Email { get; set; }
    public String PasswordHash { get; set; }
}