from PIL import Image, ImageSequence

# Open the GIF file
gif_path = "/Users/mymac/Desktop/Trains/flatland/output/1732179388.3608599/animation.gif"
with Image.open(gif_path) as gif:
    # Loop through each frame in the GIF
    for i, frame in enumerate(ImageSequence.Iterator(gif)):
        print(f"Frame {i + 1}")
