//
//  MyWebRequests.m
//  MyClockIt
//
//  Created by Deepak Bharati on 12/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "MyWebRequests.h"
#import "WeatherDatabase.h"
#import "AFNetworking.h"

@implementation MyWebRequests
{
    //for local variables...
}


+ (void)updateWeatherInfo:(WeatherView *)weatherView withLocation:(CLLocation *)location
{
    NSLog(@"updateWeatherInfo");
    
    NSString *latitudeNew=[NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
    NSString *longitudeNew=[NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
    NSLog(@"latitude===%@",latitudeNew);
    NSLog(@"longitude===%@",longitudeNew);

    //weatherAPI_URL
    NSString *creoRequestURLString=[NSString stringWithFormat:@"http://192.168.0.13/FirstDemoProject/getWeather.php?latitude=%@&longitude=%@",latitudeNew,longitudeNew];
    //NSString *creoRequestURLString=@"http://creoit.com/main/api/weather.php";
    NSURL *creoRequestURL=[NSURL URLWithString:creoRequestURLString];
    NSURLRequest *creoRequest = [NSURLRequest requestWithURL:creoRequestURL];
    NSLog(@"requestToCreo: %@",creoRequest);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
    JSONRequestOperationWithRequest:creoRequest
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSDictionary *creoJsonDictionary  = (NSDictionary *)JSON;
        NSLog(@"creo json:%@",creoJsonDictionary);
        
        NSString *tempC = [creoJsonDictionary objectForKey:@"c"];
        NSString *tempF = [creoJsonDictionary objectForKey:@"f"];
        NSInteger weatherCode = [[creoJsonDictionary objectForKey:@"weatherCode"]intValue];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults integerForKey:@"TemperatureFormat"])//1 for F, 0 for C
        {
            weatherView.tempratureLabel.text = [NSString stringWithFormat:@"%@\u00B0", tempF];
        }
        else
        {
            weatherView.tempratureLabel.text = [NSString stringWithFormat:@"%@\u00B0", tempC];
        }
        weatherView.weatherConditionLabel.text = [[WeatherDatabase database]getStringForWeatherCode:weatherCode andLocation:location];
        weatherView.weatherImageView.image = [[WeatherDatabase database] getImageForWeatherCode:weatherCode andLocation:location];
        
        [defaults setObject:[NSDate date] forKey:@"LastWeatherRequest"];
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Error in getting data from creo\n %@",error);
        //  UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
        //                                     message:[NSString stringWithFormat:@"%@",error]
        //                                     delegate:nil
        //                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // [av show];
    }];
    
    [operation start];
    
}

@end
