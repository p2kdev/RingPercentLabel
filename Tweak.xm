@interface BCUIChargeRing : UIView
	@property(nonatomic, assign, readwrite) NSInteger *percentCharge;
	@property(nonatomic, retain) UILabel *ringPercentLabel;
@end

%hook BCUIChargeRing
	%property (nonatomic, retain) UILabel *ringPercentLabel;

	-(void)layoutSubviews
	{
		%orig;
		//Move the glyph down
		UIImageView* imgView = MSHookIvar<UIImageView*>(self,"_glyphImageView");
		imgView.frame = CGRectMake(imgView.frame.origin.x,20,imgView.frame.size.width,imgView.frame.size.height);
	}

	-(void)setGlyph:(id)arg1
	{
		%orig;

		if(!self.ringPercentLabel){

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
		self.ringPercentLabel.text = [NSString stringWithFormat:@"%d", arg1];
	}
%end
