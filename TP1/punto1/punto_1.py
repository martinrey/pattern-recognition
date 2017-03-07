from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import multivariate_normal


class NormalProbabilityDensityFunction(object):
    def __init__(self, mu, sigma):
        self.mu = mu
        self.sigma = sigma
        self.function = multivariate_normal(mean=self.mu, cov=self.sigma)

    def evaluate_in(self, feature_space_point):
        return self.function.pdf(feature_space_point)


class Class(object):
    def __init__(self, probability_density_function, probability, color):
        self.probability_density_function = probability_density_function
        self.probability = probability
        self.color = color

    def probability_given_is_member(self, feature_space_point):
        return self.probability_density_function.evaluate_in(feature_space_point)


class Classifier(object):
    def __init__(self, classes):
        self.classes = classes

    def probability_density_in(self, feature_space_point):
        probability_density = 0
        for klass in self.classes:
            likeness = klass.probability_given_is_member(feature_space_point)
            probability_density += likeness * klass.probability
        return probability_density

    def render_classified_feature_space(self):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        x_grid, y_grid = np.meshgrid(np.linspace(0, 10, 100), np.linspace(0, 10, 100))

        z = []
        colors = np.empty(x_grid.shape, dtype=str)
        for i, x in enumerate(np.linspace(0, 10, 100)):
            for j, y in enumerate(np.linspace(0, 10, 100)):
                z.append(self.probability_density_in([x, y]))
                klass = max([(klass, klass.probability_given_is_member([x, y]) * klass.probability) for klass in self.classes],
			    key=lambda c: c[1])[0]
                colors[i, j] = klass.color

        z_grid = np.array(z).reshape(x_grid.shape)
        ax.plot_surface(x_grid, y_grid, z_grid, rstride=1, cstride=1, facecolors=colors, linewidth=3,
                        antialiased=True)
        plt.show()


def generate_linear_classifier():
    probability_density_function = NormalProbabilityDensityFunction(mu=[2, 2], sigma=[[1, 0], [0, 1]])
    class_1 = Class(probability_density_function=probability_density_function, probability=0.5, color='r')

    probability_density_function = NormalProbabilityDensityFunction(mu=[8, 8], sigma=[[1, 0], [0, 1]])
    class_2 = Class(probability_density_function=probability_density_function, probability=0.5, color='b')

    classifier = Classifier(classes=[class_1, class_2])
    classifier.render_classified_feature_space()


def generate_elliptic_classifier():
    probability_density_function = NormalProbabilityDensityFunction(mu=[5, 3], sigma=[[1, 0.5], [0.5, 1]])
    class_1 = Class(probability_density_function=probability_density_function, probability=0.5, color='r')

    probability_density_function = NormalProbabilityDensityFunction(mu=[6, 6], sigma=[[0.5, 0], [0, 0.5]])
    class_2 = Class(probability_density_function=probability_density_function, probability=0.5, color='b')

    classifier = Classifier(classes=[class_1, class_2])
    classifier.render_classified_feature_space()


def generate_parabolic_classifier():
    probability_density_function = NormalProbabilityDensityFunction(mu=[5, 3], sigma=[[0.1, 0.2], [0.2, 0.5]])
    class_1 = Class(probability_density_function=probability_density_function, probability=0.3, color='r')

    probability_density_function = NormalProbabilityDensityFunction(mu=[6, 6], sigma=[[0.1, 0.05], [0.05, 0.1]])
    class_2 = Class(probability_density_function=probability_density_function, probability=0.3, color='b')

    probability_density_function = NormalProbabilityDensityFunction(mu=[7, 4], sigma=[[0.5, 0.05], [0.05, 0.1]])
    class_3 = Class(probability_density_function=probability_density_function, probability=0.4, color='g')

    classifier = Classifier(classes=[class_1, class_2, class_3])
    classifier.render_classified_feature_space()


if __name__ == '__main__':
    generate_linear_classifier()
