"""Return the client name stripped of extra spaces and capitalized."""
def format_name(name):
    return name.strip().title()

"""Return the total amount for the given hours and hourly rate."""
def total_amount(hours, rate):
    return hours * rate

"""Ask for client, hours and rate, then print the invoice."""
def main():
    name = input("Enter client name: ")
    hours = float(input("Enter hours: "))
    rate = float(input("Enter hourly rate: "))

    print(f"Client: {format_name(name)}")
    print(f"Hours: {hours} x {rate:.2f} EUR")
    print(f"Total: {total_amount(hours, rate):,.2f} EUR")


main()
