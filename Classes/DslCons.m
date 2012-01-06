//
//  DslCons.m
//  DSL
//
//  Created by David Astels on 4/12/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import "DslCons.h"
#import "DslNumber.h"
#import "DslSymbol.h"
#import "DslString.h"
#import "DslFunction.h"
#import "DslDefinedFunction.h"
#import "DslNil.h"


@implementation DslCons

@synthesize head, tail;

+ (DslCons*) empty
{
  return [[DslCons alloc] initWithHead:NIL_CONS andTail:NIL_CONS];
}


+ (DslCons*) withHead:(DslExpression*)h
{
  return [[DslCons alloc] initWithHead:h andTail:NIL_CONS];
}


+ (DslCons*) withHead:(DslExpression*)h andTail:(DslExpression*)t
{
  return [[DslCons alloc] initWithHead:h andTail:t];
}


- (DslCons*) init
{
  return [DslCons empty];
}


- (DslCons*) initWithHead:(DslExpression*)h andTail:(DslExpression*)t
{
  self.head = h;
  self.tail = t;
  return self;
}


- (BOOL) booleanValue
{
  return YES;
}


- (DslCons*) copy
{
  DslCons *newNode = [DslCons withHead:head];

  if (tail) newNode.tail = [tail copy];

  return newNode;
}


- (NSString*) toStringHelper
{
  if (tail && [tail notNil]) return [NSString stringWithFormat:@"%@ %@", [head toString], [(DslCons*)tail toStringHelper]];;
  if (head && [head notNil]) return [head toString];
  return @"";
}


- (NSString*) toString
{
  return [NSString stringWithFormat:@"(%@)", [self toStringHelper]];
}

- (DslCons*) evalEachArg:(DslCons*)args
{
  DslCons *result = [DslCons empty];
  DslCons *lastResult = result;
  while ([args notNil]) {
    lastResult.tail = [DslCons withHead:[args.head eval]];
    lastResult = (DslCons*)lastResult.tail;
    args = (DslCons*)args.tail;
  }
  return (DslCons*)result.tail;
}


- (DslExpression*) eval
{
  NSString *funcName = [head stringValue];
  DslFunction *func = (DslFunction*)[DSL valueOf:[DSL internalIntern:funcName]];

  if ([func isNil]) {
    NSLog(@"Unknown function: %@", funcName);
    return NIL_CONS;
  }
  
  DslCons *args = [func preEvalArgs] ? [self evalEachArg:tail] : (DslCons*)tail;
  return [func evalWithArguments:(args)];
}


- (BOOL) compareTo:(DslExpression*)other
{
  if (![super compareTo:other]) return NO;
  if (([head isNil] && [other.head notNil]) || ([head notNil] && [other.head isNil])) return NO;
  if (![head compareTo:other.head]) return NO;
  if ([tail isNil] && [other.tail isNil]) return YES;
  if (([tail isNil] && [other.tail notNil]) || ([tail notNil] && [other.tail isNil])) return NO;
  if (![tail compareTo:other.tail]) return NO;
  return YES;
}


- (BOOL) isNil
{
  return ((head == nil) || [head isNil]) && ((tail == nil) || [tail isNil]);
}


- (BOOL) notNil
{
  return ![self isNil];
}


- (BOOL) isList
{
  return YES;
}


@end
