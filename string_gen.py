import random

def generate_string():
    length = random.randint(1, 150)
    while length % 2 != 0:
        length = random.randint(1, 200)
    array = [0 for i in range(length)]
    for i in range(random.randint(1, length)):
        position = random.randint(0, length-1)
        if position % 2 == 0:
            array[position] = random.randint(1, 255)
        else:
            array[position-1] = random.randint(1, 255)
    return array

def solve_string(array):
    tmp = 0
    tmp_credibility = 31
    start_with_zero = False

    if array[0] == 0:
        start_with_zero = True
    for i in range(len(array)):
        if i % 2 == 0:
            if array[i] != 0:
                start_with_zero = False
                tmp = array[i]
                tmp_credibility = 31
                array[i+1] = tmp_credibility
            if array[i] == 0 and not start_with_zero:
                array[i] = tmp
                if tmp_credibility > 0:
                    tmp_credibility -= 1
                array[i+1] = tmp_credibility
    return array

def main():
    validate()

    array = generate_string()
    print("Original:\n" + "".join(str(i) + ", "for i in array)[:-2])
    result = solve_string(array)
    print("\n\nSolved:\n" + "".join(str(i) + ", " for i in result)[:-2])

def validate():
    # first example test in design specification
    test_1 = [128, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 100, 0, 1, 0, 0, 0, 5, 0, 23, 0, 200, 0, 0, 0]
    test_1_result = [128, 31, 64, 31, 64, 30, 64, 29, 64, 28, 64, 27, 64, 26, 100, 31, 1, 31, 1, 30, 5, 31, 23, 31, 200, 31, 200, 30]

    # example test in test bench
    test_tb = [128, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 0, 0, 5, 0, 23, 0, 200, 0, 0, 0]
    test_tb_result = [128, 31, 64, 31, 64, 30, 64, 29, 64, 28, 64, 27, 64, 26, 100, 31, 1, 31, 1, 30, 5, 31, 23, 31, 200, 31, 200, 30]

    # example 1 in design specification
    test_ex_1 = [51, 0, 0, 0, 57, 0, 24, 0, 0, 0, 0, 0, 126, 0, 0, 0, 192, 0, 0, 0]
    test_ex_1_result = [51, 31, 51, 30, 57, 31, 24, 31, 24, 30, 24, 29, 126, 31, 126, 30, 192, 31, 192, 30]

    # example 2 in design specification
    test_ex_2 = [51] + [0 for i in range(69)]
    test_ex_2_result = [51, 31, 51, 30, 51, 29, 51, 28, 51, 27, 51, 26, 51, 25, 51, 24, 51, 23, 51, 22, 51, 21, 51, 20, 51, 19, 51, 18, 51, 17, 51, 16, 51, 15, 51, 14, 51, 13, 51, 12, 51, 11, 51, 10, 51, 9, 51, 8, 51, 7, 51, 6, 51, 5, 51, 4, 51, 3, 51, 2, 51, 1, 51, 0, 51, 0, 51, 0, 51, 0]

    # test case -> sequence starts with 0
    test_tc_1 = [0, 0, 0, 0, 12, 0, 0, 0, 14, 0]
    test_tc1_result = [0, 0, 0, 0, 12, 31, 12, 30, 14, 31]

    # test case -> memory all 0
    test_tc_2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    test_tc2_result = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    assert solve_string(test_1) == test_1_result
    assert solve_string(test_tb) == test_tb_result
    assert solve_string(test_ex_1) == test_ex_1_result
    assert solve_string(test_ex_2) == test_ex_2_result
    assert solve_string(test_tc_1) == test_tc1_result
    assert solve_string(test_tc_2) == test_tc2_result

if __name__ == "__main__":
    main()

# edge cases
# [ ] memory could be finished and k is bigger -> see if possible
# [ ] reads 0 as first value
# [ ] reads 255 as first value
# [ ] memory all 0