% cd Floorplans_simplified\
cd Heatmap_mixed\
DataSize = 25;

for i=1:DataSize
    img_name = ['triangle',sprintf('%01d',i),'.jpg'];
    img_name_UpDown = ['triangle',sprintf('%01d',i+DataSize),'.jpg']; 
    img_name_LeftRight = ['triangle',sprintf('%01d',i+DataSize*2),'.jpg']; 

    temp_img = imread(img_name);
    UpDown = flip(temp_img,1);
    LeftRight = flip(temp_img,2);

    fullDestinationFileName_UpDown = fullfile('C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\Mixed\Heatmap_mixed',img_name_UpDown);
    imwrite(UpDown,fullDestinationFileName_UpDown);
    fullDestinationFileName_LeftRight = fullfile('C:\Users\zqf5070\Desktop\InXCh\Matlab\Channel_Estimation\CNN\CNN_Furniture\Mixed\Heatmap_mixed',img_name_LeftRight);
    imwrite(LeftRight,fullDestinationFileName_LeftRight);

    clear img_name temp_img UpDown LeftRight fullDestinationFileName_UpDown fullDestinationFileName_LeftRight
end

cd ..