using Microsoft.AspNetCore.Mvc;
using TimeTrackerDb;
using TimeTrackerDb.Models;

namespace TimeTrackerBackend.Controllers;

[ApiController]
[Route("[controller]")]
public class AppController(TimeTrackerContext db) : ControllerBase
{
    [HttpPost("/login")]
    public EmployeeDto? Login([FromQuery] string email, [FromQuery] string password)
    {
        var user = db.Employees.FirstOrDefault(e => e.Email == email);
        if (user == null)
        {
            return null;
        }

        return user.PasswordHash == password ? new EmployeeDto(user.Id, user.FirstName, user.LastName) : null;
    }

    [HttpPost("/employees")]
    public Employee AddEmployee(AddEmployeeDto empIn)
    {
        var emp = new Employee
        {
            FirstName = empIn.FirstName,
            LastName = empIn.LastName,
            Email = empIn.Email,
            PasswordHash = empIn.Password
        };

        db.Employees.Add(emp);
        db.SaveChanges();
        return emp;
    }

    [HttpGet("/isWorking")]
    public bool IsWorking(int employeeId)
    {
        var started = db.TimeEntries.FirstOrDefault(x => x.EmployeeId == employeeId && x.End == null);
        return started != null;
    }

    [HttpPost("/timeEntry/start")]
    public bool StartWorking(int employeeId)
    {
        var emp = db.Employees.Find(employeeId);
        if (emp == null)
        {
            throw new HttpRequestException("Employee not found");
        }

        var started = db.TimeEntries.FirstOrDefault(x => x.EmployeeId == employeeId && x.End == null);
        if (started != null)
        {
            throw new HttpRequestException("already started working");
        }

        var newTimeEntry = new TimeEntry
        {
            EmployeeId = employeeId,
            Start = DateTime.Now,
            Comment = "",
        };
        db.TimeEntries.Add(newTimeEntry);
        db.SaveChanges();
        return true;
    }

    [HttpPost("/timeEntry/stop")]
    public bool StopWorking(int employeeId, string comment)
    {
        var emp = db.Employees.Find(employeeId);
        if (emp == null)
        {
            throw new HttpRequestException("Employee not found");
        }

        var started = db.TimeEntries.FirstOrDefault(x => x.EmployeeId == employeeId && x.End == null);
        if (started == null)
        {
            throw new HttpRequestException("not started working");
        }

        started.End = DateTime.Now;
        started.Comment = comment;
        db.SaveChanges();
        return true;
    }

    [HttpGet("/employees/{id}/timeentries")]
    public List<TimeEntryDto> GetTimeEntriesForDay(int id, DateTime day)
    {
        var dayStart = day.Date;
        var dayEnd = dayStart.AddDays(1);

        var entries = db.TimeEntries
            .Where(te => te.EmployeeId == id && te.Start >= dayStart && te.Start < dayEnd)
            .Select(te => new TimeEntryDto(
                te.Id,
                te.EmployeeId,
                te.Start,
                te.End,
                te.Comment
            ))
            .ToList();

        return entries;
    }

    [HttpGet("/employees/{id}/totalHours")]
    public List<TotalDayTimeEntryDto> GetTotalHours(int id, DateTime from, DateTime to)
    {
        var fromDate = from.Date;
        var toDate = to.Date;

        var entries = db.TimeEntries
            .Where(te => te.EmployeeId == id
                         && te.Start.Date >= fromDate
                         && te.Start.Date <= toDate)
            .ToList();

        var results = entries
            .GroupBy(te => te.Start.Date)
            .Select(g => new TotalDayTimeEntryDto(
                EmployeeId: id,
                Date: g.Key,
                Hours: g.Sum(e => (e.End - e.Start).GetValueOrDefault().TotalHours)
            ))
            .ToList();

        return results;
    }

    [HttpPut("/timeentries/{id}")]
    public TimeEntryDto EditWorkingHours(TimeEntryDto dto, int id)
    {
        // 1) Find the existing entry
        var entry = db.TimeEntries.FirstOrDefault(e => e.Id == id);
        if (entry == null)
        {
            throw new Exception($"TimeEntry not found");
        }

        // 2) Validate End is not in the future
        if (dto.End > DateTime.Now)
        {
            throw new Exception("Cannot set 'End' to a future time.");
        }

        var employeeId = entry.EmployeeId; // or dto.EmployeeId if you have it in the DTO
        bool hasOverlap = db.TimeEntries.Any(e =>
            e.Id != id // exclude the current entry being edited
            && e.EmployeeId == employeeId
            && e.Start < dto.End
            && (e.End > dto.Start));

        if (hasOverlap)
        {
            throw new Exception("This time range overlaps with an existing entry.");
        }

        // 4) If validation passes, update the fields
        entry.Start = dto.Start;
        entry.End = dto.End;
        entry.Comment = dto.Comment;

        db.SaveChanges();

        // 5) Return updated entry as DTO
        return new TimeEntryDto(
            entry.Id,
            entry.EmployeeId,
            entry.Start,
            entry.End,
            entry.Comment
        );
    }

    [HttpDelete("/timeentries/{id}")]
    public bool DeleteTimeEntry(int id)
    {
        var entry = db.TimeEntries.FirstOrDefault(e => e.Id == id);
        if (entry == null)
        {
            throw new Exception($"TimeEntry not found");
        }

        db.TimeEntries.Remove(entry);
        db.SaveChanges();

        return true;
    }
    
    [HttpPost("employees/{employeeId}/timeentries")]
    public ActionResult<TimeEntryDto> CreateWorkingHours(int employeeId, [FromBody] TimeEntryDto dto)
    {
        // 1) Validate End is not in the future
        if (dto.End > DateTime.Now)
        {
            return BadRequest("Cannot set 'End' to a future time.");
        }

        // 2) Check for overlapping entries for this employee
        bool hasOverlap = db.TimeEntries.Any(e =>
            e.EmployeeId == employeeId &&
            e.Start < dto.End &&
            (e.End > dto.Start));

        if (hasOverlap)
        {
            return BadRequest("This time range overlaps with an existing entry.");
        }

        // 3) Create a new TimeEntry entity
        var newEntry = new TimeEntry
        {
            EmployeeId = employeeId,
            Start = dto.Start,    // Make sure these DateTimes are in the correct Kind (UTC or local).
            End = dto.End,
            Comment = dto.Comment
        };

        db.TimeEntries.Add(newEntry);
        db.SaveChanges();

        // 4) Return the newly created entry as DTO
        var createdDto = new TimeEntryDto(
            newEntry.Id,
            newEntry.EmployeeId,
            newEntry.Start,
            newEntry.End,
            newEntry.Comment
        );

        return Ok(createdDto);
    }


    public record AddEmployeeDto(String FirstName, String LastName, String Email, String Password);

    public record EmployeeDto(int Id, String FirstName, String LastName);

    public record TimeEntryDto(int Id, int EmployeeId, DateTime Start, DateTime? End, String Comment);

    public record TotalDayTimeEntryDto(int EmployeeId, DateTime Date, double Hours);
}