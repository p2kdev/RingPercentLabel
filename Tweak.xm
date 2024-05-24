@interface UIView (Tweak)
	- (id)_viewControllerForAncestor;
@end

@interface BCUIChargeRing : UIView
	@property(nonatomic, assign, readwrite) NSInteger *percentCharge;
	@property(nonatomic, retain) UILabel *ringPercentLabel;
@end

@interface BCUIGlyphImageView : UIImageView
@end

@implementation BCUIGlyphImageView

@end

%hook BCUIGlyphImageView

	-(void)setFrame:(CGRect)arg1
	{
		if (([self.superview class] == objc_getClass("BCUIChargeRing")) && arg1.origin.y >= 0 && ([[self _viewControllerForAncestor] isKindOfClass:%c(BCUI2x2AvocadoViewController)]))
		{
			arg1.origin.y = 20;
			//Attempt to fix the huge bluetooth icon by standardizing the size
			BCUIChargeRing *parentView = (BCUIChargeRing*)self.superview;
			double standardSize = parentView.frame.size.height - 26;
			arg1.origin.x = parentView.frame.size.width/2 - standardSize/2;
			arg1.size.width = standardSize;
			arg1.size.height = standardSize;
		}

		%orig;
	}

%end

%hook BCUIChargeRing
	%property (nonatomic, retain) UILabel *ringPercentLabel;

	-(id)_glyphImageView {
		UIImageView *orig = %orig;
		object_setClass(orig, [BCUIGlyphImageView class]);
		return orig;
	}

	-(void)setGlyph:(id)arg1
	{
		%orig;

		if(!self.ringPercentLabel && ([[self _viewControllerForAncestor] isKindOfClass:%c(BCUI2x2AvocadoViewController)])){

			self.ringPercentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[self addSubview:self.ringPercentLabel];

			//Add constraints to the label
			self.ringPercentLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[self.ringPercentLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
			[self.ringPercentLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:7].active = YES;
			[self.ringPercentLabel.widthAnchor constraintEqualToConstant:40].active = YES;
			[self.ringPercentLabel.heightAnchor constraintEqualToConstant:20].active = YES;
			[self.ringPercentLabel setFont:[UIFont boldSystemFontOfSize:12]];
			self.ringPercentLabel.text = [NSString stringWithFormat:@"%ld", (long)self.percentCharge];
			[self.ringPercentLabel sizeToFit];
			self.ringPercentLabel.textAlignment = NSTextAlignmentCenter;
		}
	}

	-(void)setPercentCharge:(int)arg1
	{
		%orig;
		if (self.ringPercentLabel)
		{
			if (arg1 > 0)
			{
				self.ringPercentLabel.text = [NSString stringWithFormat:@"%d", arg1];
				self.ringPercentLabel.hidden = NO;
			}
			else
				self.ringPercentLabel.hidden = YES;
		}

	}
%end
