from django import template
register = template.Library()


@register.filter
def to(value, arg):
    return range(int(value), int(arg) + 1)


@register.filter
def split(value, delimiter):
    return value.split(delimiter)


@register.filter
def dict_get(d, key):
    return d.get(key)
