from homepagebuilder.interfaces import require
parsers_module = require('markdown_parsers')
handles = parsers_module.handles
InlineNode = parsers_module.InlineNode
ListItemParagraph = parsers_module.ListItemParagraph
MarkdownListItem = parsers_module.MarkdownListItem
FIRSTLINE_SPACES = parsers_module.FIRSTLINE_SPACES
Paragraph = parsers_module.Paragraph

def findcolor(node):
    for child in node.children:
        if isinstance(child,ParaColor):
            return child.color
    return None

@handles('paracolor')
class ParaColor(InlineNode):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.color = self.attrs['color']

    def convert(self):
        return ''

@handles('p')
class MyParagraph(Paragraph):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.color = findcolor(self)
        self.self_break=False

    @property
    def component_name(self):
        if self.color:
            return 'coloredp'
        else:
            return 'p'

    def get_replacement(self):
        if self.color:
            return {'style': 'ColoredPara',
                    'color': self.color}
        else:
            return {}

    def convert_children(self):
        content = ''
        for child in self.children:
            content += child.convert()
        return content

class MyListItemParagraph(ListItemParagraph):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.self_break = False
        self.color = findcolor(self)

    @property
    def component_name(self):
        if self.color:
            return 'coloredp'
        else:
            return 'listitempara'

    def get_replacement(self):
        if self.color:
            return {'style': 'ColoredListItemPara',
                    'color': self.color}
        else:
            return {}

    def convert_children(self):
        content = ''
        for child in self.children:
            content += child.convert()
        return content

@handles('li')
class MyMarkdownListItem(MarkdownListItem):
    children_paragraph_class = MyListItemParagraph
