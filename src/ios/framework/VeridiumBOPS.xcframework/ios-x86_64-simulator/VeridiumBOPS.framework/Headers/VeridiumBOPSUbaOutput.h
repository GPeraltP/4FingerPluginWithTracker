//
//  VeridiumBOPSUbaOutput.h
//  VeridiumBOPS
//
//  Created by Alex ILIE on 18/11/2019.
//  Copyright © 2019 Veridium IP Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VeridiumCore/VeridiumAbstractData.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 UBA result received from server
 */
@interface VeridiumBOPSUbaOutput : VeridiumAbstractData

/*!
 Final answer
 */
@property (readonly) NSInteger answer;

/*!
 Confidence level for provided answer
 */
@property (readonly, nonnull) NSString* answerConfidence;

/*!
 Score for UBA matching
 */
@property (readonly) double score;

/*!
 What type is this response (processed, model stable, etc)
 */
@property (readonly, nonnull) NSString* resolveType;
/*!
 Error
 */
@property (readonly, nonnull) NSString* errorMessage;
/*!
 Error cause
 */
@property (readonly, nonnull) NSString* errorCausedBy;

/*!
 is processed
 */
@property (readonly) bool isProcessed;


@end

NS_ASSUME_NONNULL_END
