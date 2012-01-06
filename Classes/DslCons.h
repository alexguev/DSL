//
//  DslCons.h
//  DSL
//
//  Created by David Astels on 4/12/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DslExpression.h"
#import "DslSymbol.h"
#import "DslNumber.h"
#import "DslString.h"

@class DslFunction;


@interface DslCons : DslExpression {
  DslExpression *head;
  DslExpression *tail;
}

@property (strong, nonatomic) DslExpression *head;
@property (strong, nonatomic) DslExpression *tail;

+ (DslCons*) empty;
+ (DslCons*) withHead:(DslExpression*)h;
+ (DslCons*) withHead:(DslExpression*)h andTail:(DslExpression*)t;

- (DslCons*) init;
- (DslCons*) initWithHead:(DslExpression*)h andTail:(DslExpression*)t;

- (DslCons*) copy;

@end
