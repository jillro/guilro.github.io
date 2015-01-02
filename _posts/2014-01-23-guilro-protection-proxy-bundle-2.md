---
layout: post
title: GuilroProtectionProxyBundle with Ocramius ProxyManager
category: symfony
comments:
  - date: 2015-01-02T23:10:27.176Z
    author: Guillaume Royer
    content: "Lorem ipsum. Chocolat. \n\n Retour à la Ligne."

---

[GuilroProtectionProxyBundle](/symfony/2014/01/21/guilro-protection-proxy-bundle.html) generates proxy objects from your configuration. Those proxies handle access granting, so you can render them without having to do authorization in your views or in your controllers. It is not completely [AOP](http://en.wikipedia.org/wiki/Aspect-oriented_programming), but it is the same idea.

I took the time this afternoon to rewrite it using [OcramiusProxyManager](https://github.com/Ocramius/ProxyManager). I was also thinking to use [JMSAopBundle](https://github.com/schmittjoh/JMSAopBundle) but I already knew a bit the first one, so I decided to stick with it. The code is now much cleaner and easier to read. You can [check it on Github](https://github.com/guilro/GuilroProtectionProxyBundle/tree/0.1.1).

* There is no break in the *documented* API.
* Lots of new tests.
* It uses [OcramiusProxyManager](https://github.com/Ocramius/ProxyManager) to generate proxies.
* New dependency on a small Zend component +1,5 Mb in memory.
* Fix a bug when using attribute and expression together.
* Removed doctrine dependency.

So you can still do :

```yaml
# app/config/config.yml

guilro_protection_proxy:
    protected_classes:
        Acme\BlogBundle\Entity\Article:
            methods:
                getComments:
                    attribute: ROLE_USER # can be a role, or any attribute a voter can handle
                    return_proxy: true   # the Comments themselves will be proxified
                    deny_value: false    # ::getComments() will return false if
                                         # ROLE_USER is not granted by security context
        Acme\BlogBundle\Entity\Comment:
            methods:
                getAuthor:
                    return_proxy: true
        Acme\BlogBundle\Entity\User:
            methods:
                getEmail:
                    expression: has(VIEW_EMAIL) # it also supports expressions
                    deny_value: ''
```
and then
{% raw %}
```jinja
{% if article.comments %}
    {% for comment in article.comments %}
        {{ comment.author.name }}
        {{ comment.author.email }}
        {{ comment.text }}
    {% endfor %}
{% endif %}
```
{% endraw %}

You just have to add two lines in your controller :

```php
<?php
$proxyManager = $this->get('guilro.protection_proxy');
$articleProxy = $proxyManager->getProxy($article);
$this->render(
    'AcmeBlogBundle:Article:show.twig.html',
    array('article' => $articleProxy)
);
```


Next step for me is adding a way to configure the ProxyManager to cache the proxy classes.  
**EDIT 27/02/2014 :** this is done !
