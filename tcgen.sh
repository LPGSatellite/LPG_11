#!/bin/bash
# This script is used to generate remote control commands. 
# Function to convert input string to hex
convert_to_hex() {
    local counter=1 # Initialize counter
    local max_words=124 # Max word count for warning
    local max_length=92 # Max byte length per part

    while IFS= read -r line; do
        # Perform environment variable substitution
        line=$(eval echo "$line")

        # Calculate the length of the input string in bytes
        input_length=${#line}
        total=$(( input_length / max_length + 1))

        # If the input is longer than 92 bytes, split it
        if (( input_length > max_length )); then
            echo "Input exceeds $max_length bytes, splitting into multiple parts..."
            # Split the input into chunks of max_length
            while (( input_length > 0 )); do
                part="${line:0:max_length}"
                line="${line:max_length}"
                input_length=${#line}
                # Call the conversion function for each part
                process_part "$part" "$counter" $total 01
                counter=$((counter + 1))
            done
        else
            # If input is within the limit, just process it
            process_part "$line" "$counter" $total 00
            counter=$((counter + 1))
        fi
    done

    # Print the results
    echo RAW
    echo -e "$result_raw_padded"
    echo "Pi"
    echo -e "$result_star_padded"
    echo "A"
    echo -e "$result_a_padded"
    echo "B"
    echo -e "$result_b_padded"

    result_raw_padded=""
    result_star_padded=""
    result_a_padded=""
    result_b_padded=""

    # Check if xclip or xsel is available to copy to clipboard
    if command -v xclip &>/dev/null; then
        echo -n "$result_no_spaces" | xclip -selection clipboard
    elif command -v xsel &>/dev/null; then
        echo -n "$result_no_spaces" | xsel --clipboard
    fi
}

# Function to process each part of the input line
process_part() {
    local part=$1
    local counter=$2
    local total=$3
    local split=$4

    # Calculate the length of the input part and convert it to uppercase hexadecimal
    length=$(printf "%X" ${#part})

    # Ensure the length is two digits (pad with 0 if necessary)
    length_hex=$(printf "%02X" 0x"$length")

    # Convert the counter to a two-digit uppercase hexadecimal value
    counter_hex=$(printf "%02X" $counter)

    total_hex=$(printf "%02X" $total)

    # Create the prefix with the dynamic length and sequence number
    prefix="65 $split $counter_hex $total_hex 00 00 00 00 00 $length_hex 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"

    # Generate the raw hexadecimal string without spaces or newlines
    raw_hex=$(echo -n "$part" | od -An -tx1 -v | tr -d ' \n' | tr 'a-f' 'A-F')

    # Insert spaces between every two characters
    formatted_hex=$(echo "$raw_hex" | sed 's/../& /g' | sed 's/ $//')

    # Combine prefix and formatted hex output
    result="$prefix $formatted_hex"

    # Calculate the word count in the result using wc -w
    word_count=$(echo "$result" | wc -w)

    # Check if the word count exceeds the maximum allowed words (124 words)
    if (( word_count > max_words )); then
        echo "Warning: The output exceeds $max_words words!"
    fi

    # Remove all spaces from the final result
    result_no_spaces=$(echo "$result" | tr -d ' ')

    # Create the three output lines with the necessary prefixes
    result_star="EB900100000100000000000001000100002E00000000008B000000001108000000030000EA627C$result_no_spaces"
    result_a="EB900100000100000000000001000100002E00000000008B000000001102000000030000EA627C$result_no_spaces"
    result_b="EB900100000100000000000001000100002E00000000008B000000001103000000030000EA627C$result_no_spaces"

    # Fill each line to 346 characters with '0'
    result_raw_padded="$result_raw_padded$result_no_spaces\n"
    result_star_padded="$result_star_padded$(printf "%-346s" "$result_star" | tr ' ' '0')\n"
    result_a_padded="$result_a_padded$(printf "%-346s" "$result_a" | tr ' ' '0')\n"
    result_b_padded="$result_b_padded$(printf "%-346s" "$result_b" | tr ' ' '0')\n"

}

# Function to translate from hex to ASCII
translate_from_hex() {
    # ANSI escape code for high-brightness white
    HIGHLIGHT_WHITE='\033[1;37m'
    RESET='\033[0m' # Reset color to default

    while IFS= read -r line; do
        # Remove the prefix part (first 32 bytes are the prefix)
        hex_part=$(echo "$line" | sed 's/^[0-9A-Fa-f ]\{1,95\} //')

        # Convert the remaining hex part to ASCII, replacing non-printable characters with a placeholder
        ascii_string=""
        for hex in $hex_part_with_spaces; do
            # Convert hex to ASCII character
            ascii_char=$(printf "\\x$hex")

            # If the character is a non-printable character (null byte, etc.), replace it with a placeholder
            if [[ "$ascii_char" == $'\x00' ]]; then
                ascii_char="<NULL>"
            elif [[ "$ascii_char" == $'\x1b' ]]; then
                ascii_char="<ESC>"
            fi

            # Append to the output string
            ascii_string+="$ascii_char"
        done

        # Print the translated result in high-brightness white
        echo -e "${HIGHLIGHT_WHITE}${ascii_string}${RESET}"
    done
}

# Function to show help message
show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [FILE...]

Convert input strings to ASCII hexadecimal representation with uppercase letters,
and prepend a dynamic prefix to each converted line, including a length field and sequence number.

OPTIONS:
  -i, --interactive    Enter interactive mode, where you can input commands.
  -r, --reverse        Reverse translate from hex to ASCII (remove prefix and decode).
  --help               Show this help message and exit.

DESCRIPTION:
  This script reads input from files or standard input, converts each character
  to its ASCII hexadecimal representation (in uppercase), prepends a dynamic prefix
  (including the length of the string in hexadecimal and a sequence number), and prints the result.
  In interactive mode, it allows for real-time input and environment variable substitution.
  In reverse mode, it decodes hex-encoded strings into readable ASCII.

EXAMPLES:
  1. From a file:
     $(basename "$0") input.txt

  2. From standard input:
     echo "Hello, World!" | $(basename "$0")

  3. Interactive mode:
     $(basename "$0") -i

  4. Reverse mode (hex to ASCII):
     $(basename "$0") -r < input_hex.txt

EOF
}

# Main execution logic
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ "$1" == "-i" || "$1" == "--interactive" ]]; then
    # Interactive mode
    echo "Entering interactive mode. Type 'exit' to quit."

    # Enable readline support and command history
    HISTFILE=~/.tcgen_history
    touch "$HISTFILE"
    history -r "$HISTFILE"

    # Define a custom prompt
    prompt="> "

    while true; do
        read -e -p "$prompt" line

        if [[ "$line" == "exit" ]]; then
            break
        fi

        # Append command to history
        history -s "$line"
        history -w "$HISTFILE"

        # Convert input to hex
        convert_to_hex <<< "$line"
    done
    exit 0
fi

# Check for -r (reverse) flag
if [[ "$1" == "-r" || "$1" == "--reverse" ]]; then
    # Reverse translation from hex to ASCII
    echo "Entering reverse mode: Hex to ASCII translation."
    translate_from_hex
    exit 0
fi

# Check if arguments (file names) are provided
if [ "$#" -gt 0 ]; then
    for file in "$@"; do
        if [ "$file" == "-" ]; then
            # Read from standard input
            convert_to_hex
        elif [ -f "$file" ]; then
            while IFS= read -r line; do
                convert_to_hex <<< "$line"
            done < "$file"
        else
            echo "Error: File '$file' not found or is not a regular file." >&2
        fi
    done
else
    convert_to_hex
fi
