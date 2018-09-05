#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#include "socket.h"
#include "usage.h"

struct output {
  char   *ptr;
  size_t len;
};

static size_t fwritefn(void *ptr, size_t size, size_t nmemb, struct output *out) {
  size_t new_len = out->len + size * nmemb;
  out->ptr = realloc(out->ptr, new_len + 1);

  if (out->ptr == NULL) {
    error("writing http response failed");
  }
  
  memcpy(out->ptr + out->len, ptr, size * nmemb);

  out->ptr[new_len] = '\0';
  out->len = new_len;

  return size * nmemb;
}

static void init_output(struct output *out) {
  out->len = 0;
  out->ptr = malloc(out->len + 1);

  if (out->ptr == NULL) {
    error("writing http response failed");
  }
  
  out->ptr[0] = '\0';
}

int socket_writef(const char *url, FILE *fp) {
  CURL  *curl;
  int   curl_response, http_response;
 
  curl = curl_easy_init();

  if (curl) {
    struct output out;
    init_output(&out);

    curl_easy_setopt(curl, CURLOPT_URL,            url);
    curl_easy_setopt(curl, CURLOPT_USERAGENT,      USERAGENT);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION,  fwritefn); 
    curl_easy_setopt(curl, CURLOPT_WRITEDATA,      &out);

    curl_response = curl_easy_perform(curl);
    
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_response);
    
    curl_easy_cleanup(curl);

    if (fp != NULL) {
      fwrite(out.ptr, out.len, 1, fp); 
    }

    free(out.ptr);
  }

  if (curl_response != CURLE_OK) {
    return curl_response;
  } else {
    return http_response;
  }
}
