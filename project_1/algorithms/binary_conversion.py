def float_to_q7_8(value):
    if value < -128 or value >= 128:
        raise ValueError("Value is out of range for Q7.8 format")

    # Scale the floating-point value to a Q7.8 fixed-point value
    q7_8_value = int(value * (1 << 8))
    
    return q7_8_value

# Example usage:
floating_point_value = 0.4
q7_8_representation = float_to_q7_8(floating_point_value)
print(q7_8_representation) 
