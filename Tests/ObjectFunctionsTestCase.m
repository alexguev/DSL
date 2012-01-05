//
//  ObjectFunctionsTestCase.m
//  DSL
//
//  Created by David Astels on 6/8/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import "ObjectFunctionsTestCase.h"


@implementation ObjectFunctionsTestCase


- (void) setUp
{
  p = [[DslParser alloc] init];  
}


- (void) testMethodCall
{
  DslObject *obj = [DslObject withObject:[NSNumber numberWithInt:5]];
  DslExpression *result = [obj getInteger:@"intValue"];
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 5, nil);
}


- (void) testMethodCallInLisp
{
  [DSL bind:[DslSymbol withName:@"obj"] to:[DslObject withObject:[NSNumber numberWithInt:5]]];
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(get-integer obj 'intValue)"]] eval];

  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 5, nil);
}


- (void) testMethodCallInSelect
{
  [DSL bind:[DslSymbol withName:@"obj1"] to:[DslObject withObject:[NSNumber numberWithInt:5]]];
  [DSL bind:[DslSymbol withName:@"obj2"] to:[DslObject withObject:[NSNumber numberWithInt:2]]];
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(select (lambda (obj) (< (get-integer obj 'intValue) 3)) (list obj1 obj2) )"]] eval];
  STAssertTrue([result isKindOfClass:[DslCons class]], nil);
  STAssertEquals([[result length] intValue], 1, nil);
}


@end
