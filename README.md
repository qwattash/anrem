Automated Non REcursive Make
=====


 Automated Non REcursive Make
 Author: Alfredo Mazzinghi (qwattash) <mzz.lrd@gmail.com>

# What is ANREM
 The ANREM system is aimed to provide an easy and extensible
 make environment for projects of any dimension with small deal
 of configuration.
 Non recursive make provides a way to avoid all the problems
 that recursion causes in make.
 
 The ANREM system is a way of managing automatic inclusion and modularization of the
 code tree and makefiles, the goal is making it easier to spread the definition of 
 targets across the code directory tree without having to worry about the order
 of inclusion or recursive make problems.
 One of the goals is also beeing less complex than GNU automake, which I find very useful
 but overly complex for certain tasks.
 
 For a nice overview of the recursive make issues see the great paper 
 "Recursive Make Considered harmful" by Peter Miller (http://aegis.sourceforge.net/auug97.pdf)
 
# What ANREM is not
 ANREM does not build your programs automatically, you still get the last word on the makefile contents.
 ANREM helps keeping your sources organised, however it's up to you to decide how your source tree should look.
 
# /b/
 I recently decided to adopt semantic versioning (http://semver.org/), from version 0.2.2 all version number will
 assume a precise meaning.

 In the system I'll try to implement everything I find useful to my own projects and try
 to keep it clean and easy. 
 
 I'm sharing this in the hope to be useful to someone else.
 
 Feel free to suggest features or patches :)

# License
 MIT. Do read the license, however this is pretty much free for everyone to use.

Alfredo Mazzinghi

