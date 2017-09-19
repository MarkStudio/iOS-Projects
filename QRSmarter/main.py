
class Student(object):
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Student object (name: %s)' % self.name

print Student('Mark')


#class Animal(object):
#    def run(self):
#        print 'Animal is running...'
#
#class Dog(Animal):
#    pass
#
#class Cat(Animal):
#    def run(self):
#        print 'Cat is Running'
#    pass
#
#dog = Dog()
#cat = Cat()
#
#dog.run()
#cat.run()


#class Student(object):
#    def __init__(self, name, score):
#        self.__name = name
#        self.__score = score
#
#    def print_grade(self):
#        print '%s, %s' % (self.__name, self.__score)
#
#    def get_name(self):
#        return self.__name
#
#    def get_score(self):
#        return self.__score
#
#bart = Student('Bart Simpon', 98)
#print bart.get_name()
#print bart.get_score()
#print bart.print_grade()

#class Student(object):
#    
#    def __init__(self, name,score):
#        self.name = name
#        self.score = score
#    
#    def get_grade(self):
#        if self.score >= 90:
#            return 'A'
#        elif self.score >= 60:
#            return 'B'
#        else:
#            return 'C'
#
#bart = Student('Bart Simpson', 59)
#print bart.name
#print bart.score
#
#print bart.get_grade();
