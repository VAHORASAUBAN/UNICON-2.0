import yt_dlp
import os
from tkinter import Tk
from tkinter.filedialog import askdirectory

def select_save_folder():
    """Open a file explorer dialog to select the save folder."""
    Tk().withdraw()  # Hide the root Tkinter window
    save_folder = askdirectory(title="Select Folder to Save the Video")
    if not save_folder:
        print("No folder selected. Exiting...")
        exit()
    return save_folder

def download_video(video_url, save_folder, custom_name=None):
    try:
        # yt-dlp options
        ydl_opts = {
            'format': 'bestvideo+bestaudio/best',  # Download the best video and audio quality
            'merge_output_format': 'mp4',  # Merge streams into an MP4 file
        }

        # Use yt-dlp to extract video information
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info_dict = ydl.extract_info(video_url, download=False)  # Get metadata without downloading
            video_title = info_dict.get('title', 'video')  # Get the video title or default to 'video'

        # Determine the file name
        file_name = f"{custom_name if custom_name else video_title}.mp4"
        ydl_opts['outtmpl'] = os.path.join(save_folder, file_name)

        # Download the video with the specified options
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([video_url])
            print(f"Video successfully downloaded as: {os.path.join(save_folder, file_name)}")
    except Exception as e:
        print(f"Error: {e}")

def main():
    # Ask for the YouTube video URL
    video_url = input("Enter the YouTube video URL: ")

    # Ask the user to select the save folder
    save_folder = select_save_folder()

    # Prompt the user for a custom file name
    custom_name = input("Enter a custom name for the video (leave blank to use the original title): ").strip()

    # Download the video
    download_video(video_url, save_folder, custom_name)

if __name__ == "__main__":
    main()
