from django import template

register = template.Library()


@register.filter
def to(value, arg):
    """
    Filter that returns a range of numbers from `value` to `arg`.
    Example: value|to:10 will return a range from value to 10.
    """
    return range(int(value), int(arg) + 1)


@register.filter
def split(value, delimiter):
    """
    Filter that splits the string `value` by the given `delimiter`.
    Example: "apple,banana"|split:"," will return ['apple', 'banana']
    """
    return value.split(delimiter)


@register.filter
def dict_get(d, key):
    """
    Filter that gets a value from a dictionary `d` for the given `key`.
    Example: dict_get(my_dict, 'key1') will return the value associated with 'key1'.
    """
    return d.get(key)

# Custom 'set' tag to simulate setting a variable


@register.simple_tag
def set_variable(value):
    """
    Custom tag to simulate the 'set' functionality.
    It assigns the given `value` to a variable that can be used in the template.
    Example: {% set_variable "some value" %}
    """
    return value
