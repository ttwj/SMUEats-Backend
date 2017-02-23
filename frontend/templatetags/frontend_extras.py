from django.template.defaulttags import register


@register.filter
def getitem ( item, string ):
  return item.get(string,'')