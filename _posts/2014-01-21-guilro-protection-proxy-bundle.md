---
layout: post
title: 'Authorization at the entity level with GuilroProtectionProxyBundle'
category: symfony
---

Last November, I went to Symfony Hack Day in Berlin. I did not talk with as many developers as I wanted, but it was the occasion for me to make [my first contribution to Symfony](https://github.com/symfony/symfony/issues/9433). I also asked a guy how I could get feedback on a bundle I had written, and he told me to put it on a blog. I spent last weeks playing with other tools than Symfony, but for some reason, I take the time to make this post.

I really like Symfony Security Component. [Voters](http://kriswallsmith.net/post/15994931191/symfony2-security-voters) are really great to implement your authorization logic in an easy and clean way. There are of course several bundles out there which add security features to Symfony. You can easily secure controllers methods, or perform security checks in your templates.

In most of small Symfony projects, I think it is very common to get doctrine entities from the database, and send them directly to Twig, like in the examples in the first pages of Symfony official documentation.

Let's say you have a blog with articles, comments, and users. You have a oneToMany association from `Acme\BlogBundle\Entity\Article` to `Acme\BlogBundle\Entity\Comment`. Then you have a oneToOne association from `Comment` to `Acme\BlogBundle\Entity\User`. Let's say you want to :

* hide all comments from anonymous users
* show comments authors
* let users choose if they will show there email address next to their names above comments. You have a voter for that.

One way to do this is to check access in templates :

{% raw %}
```jinja
{% if is_granted('ROLE_USER') %}
    {% for comment in article.comments %}
        {{ comment.author.name }}
        {% if is_granted('VIEW_EMAIL', comment.author %}
            {{ comment.author.email }}
        {% endif %}
        {{ comment.text }}
    {% endfor %}
{% endif %}
```
{% endraw %}

If you need to change your authorization criteria, for example to show email address only to `ROLE_ADMIN`, you have two solutions. You can change your `is_granted()` in all your templates where article comments appear. Or you can change your Voter handling `VIEW_EMAIL` attributes, so it follows the decision to another call to `$securityContext->isGranted('ROLE_ADMIN')`.

I think none of the above solutions is really fine. Checking permissions in the templates is not really a good idea. When you send data to your view, it should already be purged of what has not to be shown to user. It prevents from mistakes. It does not prevent you from testing if the data exists, but at least nothing *bad* will happen if you forget to do it. (*Just* errors because of undefined variable, but that is exactly what you want.)

A good way to solve this problem is to add a layer of indirection between database entities and views. In fact, any complex project would do that. But, what if we don't need to change the methods of our entities ? In our case, accessing through `post.comments` and `comment.author.email` is perfectly fine.

### Protection Proxy pattern
A Proxy Class is a class which inherits from the original class, is an interface to it and is able to replace transparently the original object. You already use them in Doctrine with lazy loading. See [The Proxy Pattern in PHP](http://ocramius.github.io/presentations/proxy-pattern-in-php/#/12). The idea is to automatize the task of building protection proxies from entity class and app config. A few months ago, I wrote this very dirty code and put it in a bundle, which basically takes parameters from `config.yml`, and generate a Proxy for you, so you can do :

```yaml
# app/config/config.yml

guilro_protection_proxy:
    protected_classes:
        Acme\BlogBundle\Entity\Article:
            methods:
                getComments:
                    attribute: ROLE_USER #can be a role, or any attribute that a voter can handle
                    return_proxy: true #the Comments themselves will be proxies
                    deny_value: false
        Acme\BlogBundle\Entity\Comment:
            methods:
                getAuthor:
                    return_proxy: true
        Acme\BlogBundle\Entity\User:
            methods:
                getEmail:
                    attribute: VIEW_EMAIL
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

###Features

* It support attributes, but you still have to set up Voters if you don't want to get stuck with the ROLE_FOOBAR attributes. I also support new Symfony Expression Language.
* It assumes you want to set permissions for all views at once. There should be no reason an information is accessible on `/foobar/list` but not on `/foobar/id/show`.
* If your entity has associations with other entities, you can ask the proxy methods to automatically return other proxies.

I took the time yesterday to add some tests, and support for new Symfony 2.4 expression language. I have to add more tests. This is the first bundle I wrote that *could* be useful to others, but this is really dirty code. I first reading [The Proxy Pattern in PHP](http://ocramius.github.io/presentations/proxy-pattern-in-php/#/12), proudly found the code for proxy in Doctrine, and modified it to fit my needs. I am planning a rewrite using [Ocramius ProxyManager](https://github.com/Ocramius/ProxyManager/blob/master/src/ProxyManager/Factory/AccessInterceptorValueHolderFactory.php).

You can check the code on [Github](https://github.com/Guilro/GuilroProtectionProxyBundle). I don't know if it can be useful for real, but it fitted my needs at some moment. There was probably a better way to do this.
