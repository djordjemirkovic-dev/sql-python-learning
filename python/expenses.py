import math


def get_amount():
    """Return list with inputs"""
    expenses = []
    while True:
        try:
            expense = input("Expense: ")

            if expense == "done":
                break

            expense = expense.replace(",", ".")
            expense = float(expense)

            if not math.isfinite(expense):
                raise ValueError

            if expense < 0:
                print("Amount cannot be negative.")
                continue

            expenses.append(expense)

        except ValueError:
            print("Please enter a number.")

    return expenses


def main():
    """Print Total, Average and Maximum values of inputed list"""
    expenses_list = get_amount()
    if len(expenses_list) == 0:
        print("No expenses entered.")
        return
    print(f"Total: {(sum(expenses_list)):.2f}")
    print(f"Average: {((sum(expenses_list)) / len(expenses_list)):.2f}")
    print(f"Largest: {max(expenses_list)}")


if __name__ == "__main__":
    main()
