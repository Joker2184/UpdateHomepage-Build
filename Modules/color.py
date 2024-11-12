from homepagebuilder.interfaces import script, require

parsers_module = require('markdown_parsers')
handles = parsers_module.handles
InlineNode = parsers_module.InlineNode
@handles('color')
class Color(InlineNode):
    def get_replacement(self):
        return {'color': self.attrs['color']}
