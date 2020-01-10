local module = {};

function swipeHorizontally()
	for i = 1,5,1 do
		touchDown(1, 600, 300);
		for i = 600,100,-50 do
			usleep(12000);
			touchMove(1, i, 300);
		end
		touchUp(1, 100, 300);

		usleep(500000);
  	end
end

function swipeVertically()
	for i = 1,5,1 do
		touchDown(1, 200, 300);
		for i = 300,900,50 do
			usleep(12000);
			touchMove(1, 200, i);
		end
		touchUp(1, 200, 900);

		usleep(500000);
  	end
end

function module.run()
	appActivate("me.autotouch.AutoTouch.ios8");
	toast("Swiping...");
	swipeVertically();
	usleep(500000);
  	toast("Switching to Home Screen...");
	appActivate("com.apple.SpringBoard");
	usleep(500000);
	swipeHorizontally();
end

return module;