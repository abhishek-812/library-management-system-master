FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set the working directory
WORKDIR /library-management-system

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python and pip
RUN powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe -OutFile C:\python.exe" \
    && Start-Process C:\python.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait \
    && Remove-Item C:\python.exe \
    && setx /M PATH $($env:PATH + ';C:\Python38\Scripts;C:\Python38') \
    && python -m pip install --upgrade pip setuptools wheel

# Install the required packages
RUN pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Set the environment variable for Flask
ENV FLASK_APP=app.py
ENV FLASk_ENV=development

# Expose the port that the Flask app will listen on
EXPOSE 5000

# Start the Flask app when the container starts
CMD ["flask", "run", "--host=0.0.0.0"]
