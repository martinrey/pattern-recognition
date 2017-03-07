import numpy
from scipy import misc
from scipy.stats import multivariate_normal


class Point(object):
    def __init__(self, row, col):
        self.row = row
        self.col = col


class Region(object):
    @classmethod
    def complete_region_for_this(cls, image):
        return Region(image, Point(0, 0), Point(1400, 1312), [1, 1, 1], calculate_mu=False)

    @classmethod
    def regions_for_this(cls, image):
        return [Region(image, Point(800, 50), Point(1100, 250), [255, 0, 0]),
                Region(image, Point(300, 430), Point(420, 550), [0, 255, 0]),
                Region(image, Point(545, 270), Point(665, 380), [0, 0, 255])]

    @classmethod
    def other_regions_for_this(cls, image):
        return [Region(image, Point(10, 600), Point(150, 800), [255, 0, 0]),
                Region(image, Point(500, 430), Point(600, 540), [0, 255, 0]),
                Region(image, Point(545, 800), Point(630, 900), [0, 0, 255])]

    def __init__(self, image, top_left_point, bottom_right_point, color, calculate_mu=True):
        self.image = image
        self.top_left_point = top_left_point
        self.bottom_right_point = bottom_right_point
        self.color = color
        if calculate_mu:
            self.mu = self._mu()
            self.sigma = self._sigma()

    def __iter__(self):
        for row in range(self.top_left_point.row, self.bottom_right_point.row):
            for col in range(self.top_left_point.col, self.bottom_right_point.col):
                yield self.image[row][col]

    def border(self, width=10):
        for row in range(self.top_left_point.row, self.bottom_right_point.row):
            for col in range(self.top_left_point.col, self.top_left_point.col + width):
                yield self.image[row][col]
            for col in range(self.bottom_right_point.col - width, self.bottom_right_point.col):
                yield self.image[row][col]
        for col in range(self.top_left_point.col, self.bottom_right_point.col):
            for row in range(self.top_left_point.row, self.top_left_point.row + width):
                yield self.image[row][col]
            for row in range(self.bottom_right_point.row - width, self.bottom_right_point.row):
                yield self.image[row][col]

    def _mu(self):
        n = 0
        mu = [0, 0, 0]
        for point in self:
            mu += point
            n += 1
        return mu / n

    def _sigma(self):
        mu = self.mu
        sigma = numpy.zeros((3, 3))
        amount = 0
        for point in self:
            v = point - mu
            sigma = sigma + numpy.outer(v, v)
            amount += 1
        return sigma / (amount - 1)


def print_regions():
    image = misc.imread('circular.jpg')
    for region in Region.regions_for_this(image):
        for point in region.border():
            for i in range(len(point)):
                point[i] = region.color[i]
    misc.imsave('regions.png', image)


def print_mus():
    image = misc.imread('circular.jpg')
    for region in Region.regions_for_this(image):
        color = region.mu
        for point in region:
            for i in range(len(point)):
                point[i] = color[i]
    misc.imsave('mus.png', image)


def print_classified():
    image = misc.imread('circular.jpg')
    regions = Region.regions_for_this(image)
    for point in Region.complete_region_for_this(image):
        region = max([(region, multivariate_normal.pdf(point, mean=region.mu, cov=region.sigma)) for region in regions], key=lambda x: x[1])[0]
        for i in range(len(point)):
                point[i] = region.color[i]
    misc.imsave('classified.png', image)


def confusion_matrix_trained():
    image = misc.imread('circular.jpg')
    regions = Region.regions_for_this(image)
    confusion = numpy.zeros((3, 3))
    for real_region_number, region in enumerate(regions):
        for point in region:
            selected_region_number = max([(i, multivariate_normal.pdf(point, mean=region.mu, cov=region.sigma)) for i, region in enumerate(regions)], key=lambda x: x[1])[0]
            confusion[real_region_number][selected_region_number] += 1
    print confusion


def print_other_regions():
    image = misc.imread('circular.jpg')
    for region in Region.other_regions_for_this(image):
        for point in region.border():
            for i in range(len(point)):
                point[i] = region.color[i]
    misc.imsave('regions.png', image)

def confusion_matrix_others():
    image = misc.imread('circular.jpg')
    regions = Region.other_regions_for_this(image)
    train_regions = Region.regions_for_this(image)
    confusion = numpy.zeros((3, 3))
    for real_region_number, region in enumerate(regions):
        for point in region:
            selected_region_number = max([(i, multivariate_normal.pdf(point, mean=region.mu, cov=region.sigma)) for i, region in enumerate(train_regions)], key=lambda x: x[1])[0]
            confusion[real_region_number][selected_region_number] += 1
    print confusion


# print_regions()
# print_mus()
# print_classified()4
# print_other_regions()
confusion_matrix_others()