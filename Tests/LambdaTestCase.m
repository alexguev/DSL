//
//  LambdaTestCase.m
//  DSL
//
//  Created by David Astels on 6/7/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import "LambdaTestCase.h"


@implementation LambdaTestCase

- (void) setUp
{
  p = [[DslParser alloc] init];  
}


- (void) testParsingEmptyLambda
{
  DslExpression *func = [[p parseExpression:[InputStream withString:@"(lambda ())"]] eval];
  STAssertTrue([func isKindOfClass:[DslFunction class]], nil);
}


- (void) testEvalingEmptyLambda
{
  DslFunction *func = (DslFunction*)[[p parseExpression:[InputStream withString:@"(lambda ())"]] eval];
  STAssertEqualObjects(NIL_CONS, [func evalWithArguments:[[DslCons alloc] init]], nil);
}


- (void) testEvalingSimpleLambda
{
  DslFunction *func = (DslFunction*)[[p parseExpression:[InputStream withString:@"(lambda () 42)"]] eval];
  DslExpression *result = [func evalWithArguments:[[DslCons alloc] init]];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}



- (void) testEvalingMoreInvolvedLambda
{
  DslFunction *func = (DslFunction*)[[p parseExpression:[InputStream withString:@"(lambda () (+ 40 2))"]] eval];
  DslExpression *result = [func evalWithArguments:[[DslCons alloc] init]];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}


- (void) testEvalingLambdaWith1Argument
{
  DslFunction *func = (DslFunction*)[[p parseExpression:[InputStream withString:@"(lambda (x) (+ x 2))"]] eval];
  [DSL bind:[DslSymbol withName:@"x"] to:[DslNumber numberWith:40]];
  DslExpression *result = [func evalWithArguments:[[DslCons alloc] init]];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}


- (void) testEvalingLambdaWithArguments
{
  DslFunction *func = (DslFunction*)[[p parseExpression:[InputStream withString:@"(lambda (x y) (+ x y))"]] eval];
  [DSL bind:[DslSymbol withName:@"x"] to:[DslNumber numberWith:40]];
  [DSL bind:[DslSymbol withName:@"y"] to:[DslNumber numberWith:2]];
  DslExpression *result = [func evalWithArguments:[[DslCons alloc] init]];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}


- (void) testApplyingSingleArgumentLambda
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(apply (lambda (x) (+ x 2)) 40)"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}  


- (void) testApplyingMultipleArgumentLambda
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(apply (lambda (x y) (+ x y)) 40 2)"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslNumber class]], nil);
  STAssertEquals([result intValue], 42, nil);
}  


@end
