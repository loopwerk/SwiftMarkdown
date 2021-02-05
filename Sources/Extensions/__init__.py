from markdown.extensions import Extension
from markdown.inlinepatterns import SimpleTagPattern
from markdown.treeprocessors import Treeprocessor

DEL_RE = r'(~~)(.*?)~~'

class StrikeThrough(Extension):
    def extendMarkdown(self, md):
        del_tag = SimpleTagPattern(DEL_RE, 'del')
        md.inlinePatterns.register(del_tag, 'del', 75)

class TitleProcessor(Treeprocessor):
    def run(self, root):
        self.md.Title = ''
        for element in root.iter('h1'):
            root.remove(element)
            self.md.Title = element.text
            break

class TitleExtension(Extension):
    def extendMarkdown(self, md):
        md.treeprocessors.register(TitleProcessor(md), 'titleprocessor', 15)
