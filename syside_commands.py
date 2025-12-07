# import syside_license
# syside_license.check()  # Validates your license
import syside

model, diagnostics = syside.load_model(["project_Electronics_Basics/electronics_basic.sysml"])
print('model loaded')



# Perhaps your python package is not updated.

## python -c "import syside; print(syside.__version__)"

# should print 0.8.2 or greater.

# It is either

## pip install syside --upgrade

# or

## uv sync -P syside
