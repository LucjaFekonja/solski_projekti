[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/dMrhZbFm)
# Homework 4: SARS-CoV-2 variants - How fast does the virus evolve?

Viruses are not immune to mutations and evolution.
During the pandemic, the SARS-CoV-2 virus mutated, evolved, and changed its characteristics, leaving us with various new strains and variants.


The evolution of new strains is tied to their rate of mutation.
Therefore, we must know how fast they mutate to understand their evolution.
Their mutation rate is meaningless without some references; thus, we will compare it to the rate of mutations of other viruses.
Apart from the rate, the location of mutations is vital for evolving new characteristics while preserving their viability.
Some specific mutations give rise to a new variant, and we will be interested in where those mutations happen in different variants.
Lastly, we will focus on Slovenia and its variant landscape throughout the pandemic.

Open `homework-4.ipynb` to get started.


## Submission and Grading

To complete the homework, you need to commit and push your images/notebook/code to your Github repository. Please read and follow the notebook instructions carefully. You do not need to submit anything else. We will open assignments on Ucilnica, but these are there only for your convenince, so the due dates are visible in your Ucilnica calendar.

For grading, we automatically generate a report for every student, so we never actually go through your code and notebooks. Our report generator automatically goes through your submission and pulls out the relevant bits.

There are three types of exercises/answers within each homework:

1. *Coding exercises* require you to implement an algorithm. We will always include Python stubs for the functions you need to implement in a separate file (most often `helper_functions.py`). Please read the function docstrings for expected parameter and return types. Coding problems will be automatically graded with unit tests.

2. *Image answers* require you to generate an image and save the plot to a corresponding file in `<img>.png`. Please ensure that your images have the exact same name as required in the instructions.

3. *Variable answers* require you to write down your answers into variables. Please be careful that the variables have the exact same name as in the instructions. We will always provide a stub in the notebook. We don't actually run your entire notebooks, we evaluate only the variable we are grading. This means that your variables should be set explicitly. For instance

    ```python
    x = 5 / 3
    answer_var = x
    ```

    will not work and will receive zero points. All answer variables should be set explicitly e.g. `answer_var = 1.6666` in for this simple example. Please ensure there are no syntax errors in your notebook.

We will automatically fetch your solutions at the deadline and these submissions will be graded by default. **If you submit after the deadline -- using your late days -- please notify Pavlin on our Slack channel**, and we will re-evaluate your submission.

## Environment instructions

You will need Python 3.8 or higher. You will need to install `biopython` for accessing NCBI and `matplotlib` for plotting. You will also need `jupyterlab` to open and run the notebook. You can also use `numpy`, `scipy`, `pandas`, and `seaborn`. You can install everything necessary by running
```
pip install biopython matplotlib jupyterlab
```
Please do not use any other libraries, because they will not be installed in the automatic grader environment and will fail, resulting in zero points. If you think some other library absolutely needs to be included, please reach out on Slack and we will discuss it there.

You can start the notebook by running
```
jupyter lab
```
and a browser window should pop open, or you can manually navigate to http://localhost:8888/ in your browser.

