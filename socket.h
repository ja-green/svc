#ifndef SOCKET_H
#define SOCKET_H

#define USERAGENT "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1"

#define HTTP_OK        200
#define HTTP_NOT_FOUND 404

int curl_url(const char *url);

#endif /* SOCKET_H */
