from mitmproxy import http

def request(flow: http.HTTPFlow) -> None:
    # pretty_url takes the "Host" header of the request into account, which
    # is useful in transparent mode where we usually only have the IP otherwise.

    if flow.request.pretty_url == "http://example.com/":
        flow.response = http.HTTPResponse.make(
            200,  # (optional) status code
            b"Hello World</br>",  # (optional) content
            {"Content-Type": "text/html"}  # (optional) headers
	)

#from mitmproxy import ctx
#
#def clientconnect(self, layer):
#    self.num = self.num + 1
#    ctx.log.info("We've seen %d flows" % self.num)
