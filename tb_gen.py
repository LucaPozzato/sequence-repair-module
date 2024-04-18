import string_gen

def generate_tb():
    with open("test_bench/tb_base.txt", "r") as file:
        tb_base_text = file.read()
        # replace address -> see what it does

        # replace string
        array = string_gen.generate_string()
        tb_base_text = tb_base_text.replace("tb_string_length", str(int(len(array)/2)))
        tb_base_text = tb_base_text.replace("tb_string", "".join(str(i) + ", " for i in array)[:-2])

        # replace expected string
        excepted_result = string_gen.solve_string(array)
        tb_base_text = tb_base_text.replace("tb_expected_string", "".join(str(i) + ", " for i in excepted_result)[:-2])
    return tb_base_text
    
def write_tb(tb_base_text, i):
    with open("test_bench/generated_tb/tb_" + str(i) + ".vhd", "w") as file:
        file.write(tb_base_text)
    
    print("Test bench " + str(i) + " generated successfully")

if __name__ == "__main__":
    for i in range(10):
        write_tb(generate_tb(), i)