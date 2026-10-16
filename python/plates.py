BAR_WEIGHT = 20
PLATES = [25, 20, 15, 10, 5, 2.5, 1.25]


def plates_for_side(side_weight):
    """Return the list of plates needed on one side"""
    used_plates = []

    for plate in PLATES:
        while plate <= side_weight:
            used_plates.append(plate)
            side_weight = round(side_weight - plate, 2)

    return used_plates


def total_weight(plates):
    """Return the total weight of the bar with those weights on both sides"""
    return (sum(plates) * 2) + BAR_WEIGHT


def main():
    weight = float(input("Enter target weight: "))
    if weight < BAR_WEIGHT:
        print("Weight is less than the bar")
        return
    side = (weight - BAR_WEIGHT) / 2
    used_plates = plates_for_side(side)
    if not used_plates:
        plates_text = "no plates"
    else:
        plates_text = " + ".join([str(plate) for plate in used_plates])
    print(f"Per side: {plates_text}")
    actual_total = total_weight(used_plates)
    print(f"Total: {actual_total} kg")

    if actual_total != weight:
        difference = weight - actual_total
        print(f"Closest below target, short by {difference:.2f} kg")


main()
