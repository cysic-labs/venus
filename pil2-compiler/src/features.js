const Context = require('./context.js');
const ExpressionItem = require('./expression_items/expression_item.js');
const path = require('path');

module.exports = class Features {
    static #features = {};
    
    // Convert snake_case a camelCase
    static snakeToCamel(str) {
        return str.replace(/_([a-z])/g, (match, letter) => letter.toUpperCase());
    }    
    static loadFeature(featureName) {
        if (Features.#features[featureName]) {
            return Features.#features[featureName];
        }
        
        try {
            // Convert the snake_case name to camelCase
            const camelCaseName = Features.snakeToCamel(featureName);

            // Construct the path to the file
            const featurePath = path.join(__dirname, 'features', `${camelCaseName}.js`);

            // Load the module
            const FeatureClass = require(featurePath);

            // Store in cache
            Features.#features[featureName] = FeatureClass;
            
            return FeatureClass;
        } catch (error) {
            return false;
        }
    }
    static getFeature(featureName) {
        return Features.#features[featureName] ?? this.loadFeature(featureName);
    }
    static extractFeatures(type, features, defaultFeatures = {}) {
        let featuresExtracted = {};
        for (const feature of features) {
            const name = feature.name;
            if (typeof featuresExtracted[name] !== 'undefined') {
                throw new Error(`Feature ${name} already defined at ${Context.sourceTag}`);
            }
            const featureCls = this.getFeature(name);
            if (!featureCls) {
                throw new Error(`Feature ${name} not found at ${Context.sourceTag}`);
            }
            if (!featureCls.config.types.includes(type)) {
                throw new Error(`Feature ${name} not allowed for type ${type} at ${Context.sourceTag}`);    
            }
            featuresExtracted[name] = Features.extractArguments(featureCls, feature);
        }
        return {...defaultFeatures,...featuresExtracted};
    }
    static extractArguments(featureCls, feature) {        
        const config = featureCls.config;
        const args = feature.args.items;
        if (args.length < config.minArgs || args.length > config.maxArgs) {
            throw new Error(`Invalid number of arguments for feature ${feature.name} at ${Context.sourceTag}`);
        }
        if (args.length < config.minArgs) {
            throw new Error(`Feature ${feature.name} requires at least ${config.minArgs} arguments, but found ${args.length} at ${Context.sourceTag}`);
        }
        if (args.length > config.maxArgs) {
            throw new Error(`Feature ${feature.name} allows at most ${config.maxArgs} arguments, but found ${args.length} at ${Context.sourceTag}`);
        }
        const res = [];
        for (let i = 0; i < args.length; i++) {
            const arg = args[i];
            let value = false;
            if (featureCls.config.args[i] !== undefined) {
                switch (featureCls.config.args[i].type) {
                    case 'option':
                        value = Features.getOptionArgument(arg, feature, i, config.args[i]);
                        break;
                    case 'num':
                        value = Features.getNumArgument(arg, feature, i, config.args[i]);
                        break;
                    case 'bigint':
                        value = Features.getBigIntArgument(arg, feature, i, config.args[i]);
                        break;
                    default:
                        throw new Error(`Unknown argument type ${argConfig.type} for feature ${feature.name} at ${Context.sourceTag}`);
                } 
                if (typeof featureCls.validateArg === 'function') {
                    value = featureCls.validateArg(value, i, arg);
                }
            }
            if (value === false) {
                throw new Error(`Invalid argument for feature ${feature.name} at index ${i} at ${Context.sourceTag}`);
            }
            res.push(value);
        }
        if (res.length === 1 && featureCls.config.directArg) {
            return res[0];
        }
        return res;
    }   
    static getOptionArgument(arg, feature, index, argConfig) {
        let value = (arg.getAlone() ?? false).name ?? false;
        if (value === false) {
            throw new Error(`Invalid argument type for feature ${feature.name} at index ${index}, expected string but found ${typeof arg} at ${Context.sourceTag}`);
        }
        if (!argConfig.values.includes(value)) {
            throw new Error(`Invalid argument value for feature ${feature.name} at index ${index}, expected one of ${argConfig.values.join(', ')} but found ${arg} at ${Context.sourceTag}`);
        }
        return value;
    }
    static getNumArgument(arg, feature, index, argConfig) {
        const value = ExpressionItem.value2num(arg);
        if (value === false) {
            throw new Error(`Invalid argument type for feature ${feature.name} at index ${index}, expected number but found ${typeof arg} at ${Context.sourceTag}`);
        }
        if (typeof argConfig.minValue !== 'undefined' && value < argConfig.minValue) {
            throw new Error(`Invalid argument value for feature ${feature.name} at index ${index}, expected greater than or equal to ${argConfig.minValue} but found ${value} at ${Context.sourceTag}`);
        }
        if (typeof argConfig.maxValue !== 'undefined' && value > argConfig.maxValue) {
            throw new Error(`Invalid argument value for feature ${feature.name} at index ${index}, expected less than or equal to ${argConfig.maxValue} but found ${value} at ${Context.sourceTag}`);
        }
        return value;
    }
    static getBigIntArgument(arg, feature, index, argConfig) {
        const value = ExpressionItem.value2bint(arg);
        if (value === false) {
            throw new Error(`Invalid argument type for feature ${feature.name} at index ${index}, expected number but found ${typeof arg} at ${Context.sourceTag}`);
        }
        if (typeof argConfig.minValue !== 'undefined' && value < argConfig.minValue) {
            throw new Error(`Invalid argument value for feature ${feature.name} at index ${index}, expected greater than or equal to ${argConfig.minValue} but found ${value} at ${Context.sourceTag}`);
        }
        if (typeof argConfig.maxValue !== 'undefined' && value > argConfig.maxValue) {
            throw new Error(`Invalid argument value for feature ${feature.name} at index ${index}, expected less than or equal to ${argConfig.maxValue} but found ${value} at ${Context.sourceTag}`);
        }
        return value;
    }
}