@Grab(group = 'org.codehaus.groovy.modules.http-builder', module = 'http-builder', version = '0.7.1')

import static groovyx.net.http.ContentType.TEXT
import static groovyx.net.http.ContentType.URLENC
import static groovyx.net.http.Method.POST

import groovyx.net.http.HTTPBuilder

def http = new HTTPBuilder('http://localhost:7001')

def wem = '/cs/REST'
List<String> cookies = []
String ltick = ""
String form = ""

def collectCookie(resp, cookies) {
    resp.getHeaders('Set-Cookie').each {
        String cookie = it.value.split(';')[0]
        //println("Adding cookie to collection: $cookie")
        cookies.add(cookie)
    }
}

def dump(resp, body) {
    for (key in resp.headers) {
        println ">$key"
    }
    if (body)
        body.each { println it }
}

/*
redir = http.get(path: "${wem}/sites") { resp, body ->
    resp.headers?.Location
    dump(resp, body)
}*/

http.client.getParams().setParameter("http.protocol.handle-redirects", true)

http.get(path: "${wem}/sites", contentType: TEXT) { resp, html ->
    collectCookie(resp, cookies)
    def lt = ~/.*name="lt" value="(.*?)".*/
    def ac = ~/.*action="(.*?)".*/

    html.each {
        println(it)
        def m = lt.matcher(it)
        if (m.matches()) ltick = m[0][1]
        m = ac.matcher(it)
        if (m.matches()) form = m[0][1]
    }
    //dump(resp)
    //next = resp.getHeaders("Location").first
}



println("cookies:${cookies}")
println("ticket: ${ltick}")
println("form: ${form}")


http.client.getParams().setParameter("http.protocol.handle-redirects", false)
http.post(path: form, requestContentType: URLENC,
        headers: ['Cookie': cookies.join(";")],
        body: [username: 'fwadmin', password: 'xceladmin', lt: ltick]) { resp, body ->
    dump(resp, body)
}

/*
http.request(POST, TEXT) { req ->
    req.headers.put('Cookie', cookies.join(";"))
    req.body = [username: 'fwadmin', password: 'xceladmin', lt: ltick]
    req.path = form
    req.requestContentType = URLENC
    response.success {
        dump(resp,body)
    }
}*/

