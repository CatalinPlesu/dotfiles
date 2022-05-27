#!/bin/python
import matplotlib.pyplot as plt
import csv
import os
import math
import argparse

color = ['b', 'g', 'r', 'y', 'm', 'c', 'k', 'w']


def export_csv_file(file, filename):
    with open(f"{filename}_T.csv", 'w') as f:
        csv.writer(f).writerows(file)

def read_csv_file(filename):
    file = []
    with open(filename,'r') as csvfile:
        plots = csv.reader(csvfile, delimiter = ',')
        for row in plots:
            file.append(row)
    return file

def clean_csv_matrix(file):
    max_row_len = len(file[0])
    for i,r in enumerate(file):
        for j,c in enumerate(file[i]):
            if c == '':
                file[i][j] = 0
            try:
                # file[i][j] = round(float(c), 4)
                file[i][j] = float(c)
            except:
                pass

        if len(r) < max_row_len:
            file[i].append(0)
    return file

def transpose_csv_matrix(file):
    zipped_rows = zip(*file)
    return [list(row) for row in zipped_rows]

def print_csv_matrix(matrix):
    for r in matrix:
        print(*r)

def plot_to_png(file, filename):
    x = file[args.main][1:len(file[args.main])]
    l_y = []
    yn = []
    y_max = 0
    y_min = 0
    for i, line in enumerate(file):
        if i != args.main and i not in args.ignore:
            if args.plot == [] or i in args.plot:
                if -1 in args.ignore and i == len(file) - 1:
                    break
                l_y.append(file[i][0])
                #yn are all lines tha will be ploted on oy
                yn.append(file[i][1:len(file[i])])
                if y_max < max(yn[len(yn)-1]):
                    y_max = max(yn[len(yn)-1])
                if y_min < min(yn[len(yn)-1]):
                    y_min = min(yn[len(yn)-1])

    y_max = math.ceil(y_max)
    y_min = math.floor(y_min)

    # output size
    plt.figure(figsize=(args.width, args.height))

    # OX, OY axes
    plt.axhline(0, color='#696969')
    plt.axvline(0, color='#696969')

    for i, y in enumerate(yn):
        plt.plot(x, y, color = color[i], linestyle = 'solid', marker = 'o',label = l_y[i])

    plt.grid()
    plt.xlabel(file[0][0] if args.x_label == 'ox' else args.x_label)
    plt.ylabel(args.y_label)
    plt.title(args.title)
    plt.legend()

    if args.verbose:
        plt.show()
    else:
        plt.savefig(f"{args.output_dir}/{filename}.png", dpi=100)


def plotting_stuff():
    if args.filename:
        fileNames = [args.filename]
        args.output_dir = '.' if args.output_dir == 'png' else args.output_dir
        args.input_dir = './'
    else:
        fileNames = os.listdir(args.input_dir)
        fileNames = [file for file in fileNames if '.csv' in file and '#' not in file]

    if args.output_dir != '.':
        args.output_dir = args.input_dir + '_t' if args.transpose else args.output_dir
        if not args.verbose:
            try:
                os.mkdir(args.output_dir)
            except:
                pass

    for filename in fileNames:
        print(filename, "was loaded")
        if args.filename:
            file = read_csv_file(args.input_dir + filename)
        else:
            file = read_csv_file(args.input_dir + "/" + filename)
        file = clean_csv_matrix(file)

        if args.debug:
            print_csv_matrix(file)
    
        try:
            float(file[0][len(file[0])-1])
        except:
            file = transpose_csv_matrix(file)
            if args.debug:
                print("Transposed csv file")
                print_csv_matrix(file)
            print("File had to be transposed")

        if args.transpose:
            file = transpose_csv_matrix(file)
            export_csv_file(file, args.output_dir + '/' + filename[0:len(filename)-4])
            continue

        if args.filename:
           filename = os.path.basename(args.filename)
           args.filename = filename
        plot_to_png(file, filename[0:len(filename)-4])
        print(filename, "SUCCESSFULLY plotted to",
                f"{args.output_dir}/{filename}.png")


### for terminal arguments
parser = argparse.ArgumentParser(description="""
        Program to plot csv files - made by Catalin
        first row will be used for the OX axis
        and the following rows will be used for the OY axis
        Is important for information to be stored in rows!!!
        Use -t to transpose the file
        To be noted first column will be used as labels
        """)

parser.add_argument('-v', action='store_true',
        help='verbose', dest='verbose')

parser.add_argument('-d', action='store_true',
        help='debug; output csv file content if something went wrong', dest='debug')

parser.add_argument('--transpose', action='store_true',
        help="""transpose csv file, wont plot anything will create a new 
        folder with transposed csv content""", dest='transpose')

parser.add_argument('-f', help='plot only one file',
        dest='filename', default=None)

parser.add_argument("-i", dest="input_dir", default='csv',
        help="input directory, default ./csv", metavar="DIR")

parser.add_argument("-o", dest="output_dir", default='png',
        help="output directory, default ./png", metavar="DIR")

parser.add_argument("-x", dest="x_label", default='ox',
        help="x label", metavar="'str'")

parser.add_argument("-y", dest="y_label", default='oy',
        help="y label", metavar="'str'")

parser.add_argument("-t", dest="title", default='Title',
        help="title", metavar="'str'")

parser.add_argument("--main", type=int, default=0,
        help="""select which of the rows or columns should be used as x axis, 0
        will be the first index""")

parser.add_argument("--ignore", type=int, nargs="+", default=[],
        help="""select which of the rows or columns shouldn't be used, 0
        will be the first index, -1 will ignore the last element""")

parser.add_argument("--plot", dest="plot", nargs="+", type=int, default=[],
        help="""choose what columns or rows to use for plotting y axis, 0
        will be the first index""")

parser.add_argument("--height", type=int, default=6, dest='height',
        help="""for aspect ratio default 6""")

parser.add_argument("--width", type=int, default=6, dest='width',
        help="""for aspect ratio default 6""")

if __name__ == "__main__":
    args = parser.parse_args()
    if args.debug:
        print("args:", args)
    plotting_stuff()

