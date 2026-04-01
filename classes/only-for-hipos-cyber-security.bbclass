# This class can be inherited by recipes that should only be included by hipos-cyber-security distro
# Using the recipe on any other distro will lead to an error

python () {
    if d.getVar("DISTRO") != "hipos-cyber-security":
        raise bb.parse.SkipRecipe("Recipe only supported for hipos-cyber-security")
}
