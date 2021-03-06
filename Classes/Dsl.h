//
//  Dsl.h
//  DSL
//
//  Created by David Astels on 4/12/10.
//  Copyright 2010 Dave Astels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputStream.h"
#import "DslParser.h"
#import "DslExpression.h"
#import "DslString.h"
#import "DslNumber.h"
#import "DslBoolean.h"
#import "DslSymbol.h"
#import "DslCons.h"
#import "DslFunction.h"
#import "DslObject.h"
#import "DslNil.h"
#import "SymbolTable.h"

@class DslBuiltinFunction;

@class Dsl;
extern Dsl *DSL;
extern DslNil *NIL_CONS;


@interface Dsl : NSObject {
  DslParser *parser;
  SymbolTable *symbolTable;
}

+ (void) initialize;
- (Dsl*) init;

- (DslExpression*) bindName:(NSString*)name toTarget:(NSObject*)target andSelector:(SEL)selector;
- (DslExpression*) parse:(NSString*)codeString;

- (DslCons*) arrayToList:(NSArray*)anArray;
- (DslCons*) arrayToBoxedList:(NSArray*)anArray;
- (DslCons*) makeList:(DslExpression*)first, ...;
- (DslSymbol*) internalIntern:(NSString *)name;
- (DslCons *)internalAssoc:(DslSymbol*)key in:(DslCons*)list;
- (DslExpression*) bind:(DslSymbol*)symbol to:(DslExpression*)value;
- (DslExpression*) valueOf:(DslSymbol*)symbol;
- (void) pushLocalBindings;
- (void) popLocalBindings;

- (DslExpression*) apply:(DslFunction*)func to:(DslCons*)args;
- (DslExpression*) eval:(DslExpression*)sexp;
- (DslExpression*) evalEach:(DslCons*)list;
- (DslExpression*) doList:(DslCons*)args;


// function functions

- (DslFunction*) lambda:(DslCons*)args;
- (DslFunction*) defun:(DslCons*)args;
- (DslFunction*) defBuiltin:(DslCons*)args;
- (DslExpression*) apply:(DslCons*)args;
- (DslExpression*) let:(DslCons*)args;
- (DslSymbol *) intern:(DslCons *)args;

// list functions

- (DslCons*) cons:(DslCons*)args;

- (DslExpression*) car:(DslCons*)args;
- (DslExpression*) cdr:(DslCons*)args;

- (DslExpression*) caar:(DslCons*)args;
- (DslExpression*) cadr:(DslCons*)args;
- (DslExpression*) cdar:(DslCons*)args;
- (DslExpression*) cddr:(DslCons*)args;

- (DslExpression*) caaar:(DslCons*)args;
- (DslExpression*) caadr:(DslCons*)args;
- (DslExpression*) cadar:(DslCons*)args;
- (DslExpression*) caddr:(DslCons*)args;
- (DslExpression*) cadddr:(DslCons*)args;

- (DslExpression*) cdaar:(DslCons*)args;
- (DslExpression*) cdadr:(DslCons*)args;
- (DslExpression*) cddar:(DslCons*)args;
- (DslExpression*) cdddr:(DslCons*)args;

- (DslNumber*) length:(DslCons*)args;

- (DslCons*) map:(DslCons*)args;
- (DslCons*) select:(DslCons*)args;
- (DslBoolean*) any:(DslCons*)args;

- (DslExpression*) cond:(DslCons*)args;
- (DslBoolean*) logicalOr:(DslCons*)args;
- (DslBoolean*) logicalAnd:(DslCons*)args;
- (DslBoolean*) logicalNot:(DslCons*)args;

- (DslNumber*) add:(DslCons*)args;
- (DslNumber*) subtract:(DslCons*)args;
- (DslNumber*) multiply:(DslCons*)args;
- (DslNumber*) divide:(DslCons*)args;
- (DslNumber*) modulus:(DslCons*)args;

- (DslBoolean*) lessThan:(DslCons*)args;
- (DslBoolean*) greaterThan:(DslCons*)args;
- (DslBoolean*) equalTo:(DslCons*)args;


- (DslString*) getString:(DslCons*)args;
- (DslNumber*) getInteger:(DslCons*)args;
- (DslBoolean*) getBoolean:(DslCons*)args;
  
- (DslExpression*) loadFileFromPathname:(NSString*)pathname;
- (DslExpression*) loadFile:(NSString*)filebasename;
- (DslExpression*) exec:(NSString*)code;
@end
