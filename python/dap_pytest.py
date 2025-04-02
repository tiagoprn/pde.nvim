def is_palindrome(text):
    """
    Check if a string is a palindrome (reads the same forward and backward).

    Args:
        text: A string to check

    Returns:
        True if the string is a palindrome, False otherwise
    """
    # Convert to lowercase and remove non-alphanumeric characters
    cleaned_text = ''.join(char.lower() for char in text if char.isalnum())

    # Check if the string equals its reverse
    return cleaned_text == cleaned_text[::-1]

def test_simple_palindrome():
    word = "racecar"
    assert is_palindrome(word) is True

def test_palindrome_with_spaces():
    word = "A man a plan a canal Panama"
    assert is_palindrome(word) is True

def test_non_palindrome():
    word = "hello"
    assert is_palindrome(word) is False
