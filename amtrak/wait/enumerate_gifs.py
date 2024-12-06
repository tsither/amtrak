from PIL import Image, ImageSequence, ImageDraw, ImageFont

# Open the GIF file
gif_path = "/Users/mymac/Desktop/Trains/flatland/output/1732179388.3608599/animation.gif"
output_path = "output_numbered_gif.gif"

with Image.open(gif_path) as gif:
    frames = []  # Store modified frames
    font = ImageFont.load_default()  # Load a default font

    for i, frame in enumerate(ImageSequence.Iterator(gif)):
        # Convert frame to RGB mode to draw on it
        frame = frame.convert("RGB")
        draw = ImageDraw.Draw(frame)

        # Add number text to the frame (centered in this example)
        text = f"{i + 1}"
        text_width, text_height = draw.textsize(text, font=font)
        width, height = frame.size
        position = ((width - text_width) // 2, (height - text_height) // 2)
        draw.text(position, text, fill="white", font=font)

        # Convert back to the original mode (if needed) and append
        frames.append(frame.convert(gif.mode))

    # Save the modified frames as a new GIF
    frames[0].save(
        output_path,
        save_all=True,
        append_images=frames[1:],
        duration=gif.info["duration"],  # Preserve duration
        loop=gif.info["loop"],          # Preserve loop settings
    )

print(f"Numbered GIF saved as {output_path}")
