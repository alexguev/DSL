//
//  ListFunctionsTestCase.m
//  DSL
//
//  Created by David Astels on 4/15/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import "ListFunctionsTestCase.h"


@implementation ListFunctionsTestCase


- (void) setUp
{
  p = [[DslParser alloc] init];  
}


- (void) testLengthOfSimpleLists
{
//  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '())"]] eval] intValue], 0, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a))"]] eval] intValue], 1, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a b))"]] eval] intValue], 2, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a b c))"]] eval] intValue], 3, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a b c d))"]] eval] intValue], 4, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a a a a a a a a a a a a a a a a))"]] eval] intValue], 16, nil);
}

- (void) testLengthOfNestedLists
{
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '((a) b))"]] eval] intValue], 2, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a (b) c))"]] eval] intValue], 3, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a (b c) d))"]] eval] intValue], 3, nil);
  STAssertEquals([[[p parseExpression:[InputStream withString:@"(length '(a (a a) a (a) a (a ((a) a) a a) a (a a) a a))"]] eval] intValue], 10, nil);
}


- (void) testCarCdr
{
  STAssertEquals([[DSL car:(DslCons*)[p parseExpression:[InputStream withString:@"(1 2 3 4 5)"]]] intValue], 1, nil);
  STAssertEquals([[DSL cadr:(DslCons*)[p parseExpression:[InputStream withString:@"(1 2 3 4 5)"]]] intValue], 2, nil);
  STAssertEquals([[DSL caddr:(DslCons*)[p parseExpression:[InputStream withString:@"(1 2 3 4 5)"]]] intValue], 3, nil);
}


- (void) testDegenerateMap
{
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(map (lambda (l) 42) '((1) (2 2) (3 3 3)) )"]] eval];
  STAssertTrue([result isMemberOfClass:[DslCons class]], nil);
  STAssertTrue([[DSL car:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL car:result] intValue], 42, nil);
  STAssertTrue([[DSL cadr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL cadr:result] intValue], 42, nil);
  STAssertTrue([[DSL caddr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL caddr:result] intValue], 42, nil);
  STAssertNil([DSL cdddr:result], nil);
}


- (void) testMapOverSingletonList
{
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(map (lambda (l) (length l)) '((1)) )"]] eval];
  STAssertTrue([[DSL car:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL car:result] intValue], 1, nil);
  STAssertNil([DSL cdr:result], nil);
}



- (void) testAnIdentityMap
{
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(map (lambda (l) l) '(1) )"]] eval];
  STAssertTrue([[DSL car:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL car:result] intValue], 1, nil);
  STAssertNil([DSL cdr:result], nil);
}



- (void) testMap
{
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(map (lambda (l) (length l)) '((1) (2 2) (3 3 3)) )"]] eval];
  STAssertTrue([[DSL car:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL car:result] intValue], 1, nil);
  STAssertTrue([[DSL cadr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL cadr:result] intValue], 2, nil);
  STAssertTrue([[DSL caddr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL caddr:result] intValue], 3, nil);
  STAssertNil([DSL cdddr:result], nil);
}


- (void) testMap2
{
  DslCons *result = (DslCons*)[[p parseExpression:[InputStream withString:@"(map (lambda (l) (+ 1 l)) '(0 1 2) )"]] eval];
  STAssertTrue([[DSL car:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL car:result] intValue], 1, nil);
  STAssertTrue([[DSL cadr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL cadr:result] intValue], 2, nil);
  STAssertTrue([[DSL caddr:result] isMemberOfClass:[DslNumber class]], nil);
  STAssertEquals([[DSL caddr:result] intValue], 3, nil);
  STAssertNil([DSL cadddr:result], nil);
}


- (void) testCopyReturnValue
{
  DslExpression *list = [p parseExpression:[InputStream withString:@"()"]];
  STAssertNotNil([list copy], nil);
  STAssertTrue([[list copy] isKindOfClass:[DslCons class]], nil);
}


- (void) testCopyEmptyList
{
  DslCons *list = (DslCons*)[p parseExpression:[InputStream withString:@"()"]];
  STAssertEquals([[list length] intValue], 0, nil);
  STAssertNil([DSL car:list], nil);
  STAssertNil([DSL cdr:list], nil);
}


- (void) testCopySingletonList
{
  DslCons *list = (DslCons*)[p parseExpression:[InputStream withString:@"(a)"]];
  STAssertEquals([[list length] intValue], 1, nil);
  STAssertNotNil([DSL car:list], nil);
  STAssertNil([DSL cdr:list], nil);
  STAssertEqualObjects([[DSL car:list] identifierValue], @"a", nil);
}


- (void) testCopyNontrivialList
{
  DslCons *list = (DslCons*)[p parseExpression:[InputStream withString:@"(a 2)"]];
  STAssertEquals([[list length] intValue], 2, nil);
  STAssertNotNil([DSL car:list], nil);
  STAssertNotNil([DSL cdr:list], nil);
  STAssertEqualObjects([[DSL car:list] identifierValue], @"a", nil);
  STAssertNotNil([DSL cadr:list], nil);
  STAssertNil([DSL cddr:list], nil);
  STAssertEquals([[DSL cadr:list] intValue], 2, nil);
}



- (void) testSelect
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(select (lambda (l) (< (length l) 3)) '((1) (2 2) (3 3 3) (4 4 4 4) (5 5 5 5 5)) )"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslCons class]], nil);
  STAssertEquals([[result length] intValue], 2, nil);
}


- (void) testAnyWithNone
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(any? (lambda (i) (< i 3)) '(3 4 5)"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslBoolean class]], nil);
  STAssertFalse([result booleanValue], nil);
}


- (void) testAnyWithOne
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(any? (lambda (i) (< i 3)) '(1 4 5)"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslBoolean class]], nil);
  STAssertTrue([result booleanValue], nil);
}


- (void) testAnyWithMultiple
{
  DslExpression *result = [[p parseExpression:[InputStream withString:@"(any? (lambda (i) (< i 3)) '(1 4 2)"]] eval];
  STAssertNotNil(result, nil);
  STAssertTrue([result isKindOfClass:[DslBoolean class]], nil);
  STAssertTrue([result booleanValue], nil);
}


@end
