OVERTIME_THRESHOLD = 40
OVERTIME_MULTIPLIER = 1.5
MAX_WEEKLY_HOURS = 60


def is_overtime(hours):
    """Return True if hours exceed the overtime threshold."""
    return hours > OVERTIME_THRESHOLD


def regular_pay(hours, rate):
    """Calculate regular  pay"""
    hours = min(OVERTIME_THRESHOLD, hours)
    return hours * rate


def overtime_pay(hours, rate):
    """Calculate overtime pay"""
    if is_overtime(hours):
        return (hours - OVERTIME_THRESHOLD) * rate * OVERTIME_MULTIPLIER
    else:
        return 0


def main():
    hours = float(input("Enter working hours: "))
    rate = float(input("Enter hourly rate: "))
    if hours < 0 or rate < 0:
        print("Invalid input")
        return
    regular = regular_pay(hours, rate)
    overtime = overtime_pay(hours, rate)
    print(f"Regular: {regular:.2f} EUR")
    print(f"Overtime: {overtime:.2f} EUR")
    print(f"Total: {(regular + overtime):.2f} EUR")
    if hours > MAX_WEEKLY_HOURS:
        print(f"More than {MAX_WEEKLY_HOURS} hours worked this week")


main()
