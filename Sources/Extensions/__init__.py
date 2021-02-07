from markdown import util
from markdown.extensions import Extension
from markdown.inlinepatterns import SimpleTagPattern, Pattern
from markdown.treeprocessors import Treeprocessor

DEL_RE = r'(~~)(.*?)~~'

class StrikeThroughExtension(Extension):
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


###########################################################
#### source: https://github.com/r0wb0t/markdown-urlize ####
###########################################################

URLIZE_RE = '(%s)' % '|'.join([
    r'<(?:f|ht)tps?://[^>]*>',
    r'\b(?:f|ht)tps?://[^)<>\s]+[^.,)<>\s]',
    r'\bwww\.[^)<>\s]+[^.,)<>\s]',
    r'[^(<\s]+\.(?:com|net|org)\b',
])

class UrlizePattern(Pattern):
    """ Return a link Element given an autolink (`http://example/com`). """
    def handleMatch(self, m):
        url = m.group(2)

        if url.startswith('<'):
            url = url[1:-1]

        text = url

        if not url.split('://')[0] in ('http','https','ftp'):
            if '@' in url and not '/' in url:
                url = 'mailto:' + url
            else:
                url = 'http://' + url

        el = util.etree.Element("a")
        el.set('href', url)
        el.text = util.AtomicString(text)
        return el

class UrlizeExtension(Extension):
    """ Urlize Extension for Python-Markdown. """

    def extendMarkdown(self, md):
        """ Replace autolink with UrlizePattern """
        md.inlinePatterns['autolink'] = UrlizePattern(URLIZE_RE, md)
