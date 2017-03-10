from django.template.defaulttags import register


@register.filter
def getitem ( item, string ):
  return item.get(string,'')

@register.filter
def items_total(your_dict_list):
   return sum(d.menu_item.price for d in your_dict_list.all())

@register.filter
def multiply( value, arg ):
    '''
    Divides the value; argument is the divisor.
    Returns empty string on any error.
    '''
    try:
        arg = int( arg )
        if arg: return value * arg
    except: pass
    return ''