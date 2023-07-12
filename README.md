# Custom video player in swift using AVPlayer
Custom video player in swift using AVPlayer <br><br>
![Screenshot 2023-06-15 at 3 46 20 PM](https://github.com/Experimenters1/CustomvideoplayerinswiftusingAVPlayer/assets/64000769/1e249da8-a07c-49b1-a6dd-2db457036284)<br><br>

![Screenshot 2023-07-05 at 2 29 43 PM](https://github.com/Experimenters1/Custom_video_player_in_swift_using_AVPlayer/assets/64000769/7d74e20a-60f5-4d0c-8a39-39b7f6f6168b)
 <br><br>

![Screenshot 2023-07-05 at 2 29 51 PM](https://github.com/Experimenters1/Custom_video_player_in_swift_using_AVPlayer/assets/64000769/7a7ed4f8-bc86-4c4b-be64-930d9635ddbd)
 <br>



# In iOS, there are three values for the videoGravity attribute of AVPlayerLayer to display videos with different aspect ratios (Trên iOS, có ba giá trị cho thuộc tính videoGravity của AVPlayerLayer để hiển thị video với các tỷ lệ khung hình khác nhau:): <br>
![Screenshot 2023-06-18 at 9 10 22 AM](https://github.com/Experimenters1/Custom_video_player_in_swift_using_AVPlayer/assets/64000769/b885ca1c-8bdf-404b-b25e-ac6572972cc3)<br>

1.`.resizeAspect `: This value scales the video to fit within the layer's bounds while maintaining the aspect ratio. The entire video is visible, but there may be letterboxing (black bars) if the aspect ratio of the video and layer do not match.(Video sẽ được hiển thị trong layer với tỷ lệ khung hình gốc, nhưng sẽ được điều chỉnh kích thước để lấp đầy toàn bộ kích thước khung hình của layer mà không bị méo hoặc biến dạng. Phần video không bị cắt đi, nhưng có thể có dải trắng xuất hiện nếu tỷ lệ khung hình của layer và video khác nhau.)<br>
![Screenshot 2023-06-18 at 9 11 36 AM](https://github.com/Experimenters1/Custom_video_player_in_swift_using_AVPlayer/assets/64000769/34e7b78f-df9a-4157-a7db-c250735fbde3)<br>

2.`.resizeAspectFill`: This value scales the video to fill the layer's bounds while maintaining the aspect ratio. The video may be cropped, but there are no letterboxing. This ensures that the layer is completely filled with the video.(Giống như trong ví dụ trước, video sẽ được hiển thị với tỷ lệ khung hình gốc, nhưng cũng sẽ điều chỉnh kích thước để lấp đầy toàn bộ kích thước khung hình của layer. Tuy nhiên, khác với .resizeAspect, giá trị này sẽ cắt bỏ các phần không cần thiết của video để phù hợp với tỷ lệ khung hình của layer. Kết quả là video sẽ lấp đầy toàn bộ layer mà không có dải trắng xuất hiện.)<br>
![Screenshot 2023-06-18 at 9 12 46 AM](https://github.com/Experimenters1/Custom_video_player_in_swift_using_AVPlayer/assets/64000769/f3470483-51db-4fde-849b-4cfbd80a30ed)<br>

3.`.resize` : This value scales the video to fill the layer's bounds, disregarding the aspect ratio. The video may appear stretched or distorted if the aspect ratio of the video and layer differ. This option does not preserve the original aspect ratio.(Video sẽ được thay đổi kích thước để lấp đầy toàn bộ kích thước khung hình của layer, mà không quan tâm đến tỷ lệ khung hình gốc của video. Điều này có thể làm méo hoặc biến dạng video nếu tỷ lệ khung hình của layer và video khác nhau.)<br><br>

These videoGravity values allow developers to control how videos are displayed within AVPlayerLayer in iOS applications, adapting to different aspect ratios and ensuring the desired visual effect.(Bằng cách chọn giá trị phù hợp cho videoGravity, bạn có thể điều chỉnh cách hiển thị video trong AVPlayerLayer trên iOS để đáp ứng nhu cầu của ứng dụng của mình.)<br><br>

<a href="[audio not play when app in background mode in device](https://stackoverflow.com/questions/54231319/audio-not-play-when-app-in-background-mode-in-device)https://stackoverflow.com/questions/54231319/audio-not-play-when-app-in-background-mode-in-device" target="_blank" >audio_not_play_when_app_in_background_mode_in_device</a><br><br>

[audio_not_play_when_app_in_background_mode_in_device](https://stackoverflow.com/questions/54231319/audio-not-play-when-app-in-background-mode-in-device)


